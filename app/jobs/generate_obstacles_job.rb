class GenerateObstaclesJob < ApplicationJob
  queue_as :default

  def perform(entry, obstacle_in_progress)
    @entry = entry
    @obstacle_in_progress = obstacle_in_progress

    begin
      turn_to_summary(@entry.content)
      get_entry_vector(@entry.content)
      # match_summary(@entry.content)
      match_through_vectors

      # if @match.include?("fs") || @match.include?("false")
      #   set_obstacle
      # else
      #   update_entry
      # end
      summarize_entries_in_obstacle
      get_obstacle_vector
      get_recommendations
      obstacle_status_completed
    rescue
      perform(@entry, @obstacle_in_progress)
    end
  end

  private

  # ENTRY/OBSTACLE STARTS
  def delete_obstacle_in_progress
    @obstacle_in_progress.destroy
  end

  def turn_to_summary(entry)
    gpt_summary_entry(entry)
    @summary = @gpt_summary["choices"][0]["message"]["content"]
    @summary.chop! if @summary.last == "."
    @entry.update(summary: @summary)
  end

  def gpt_summary_entry(entry)
    @client = OpenAI::Client.new
    @gpt_summary = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
          content: "Create a title that summarizes this entry.
          Include proper nouns and use 7 words or less: #{entry}" }],
          temperature: 0.1
      }
    )
  end

  # VECTOR ASSIGNMENT TO ENTRY AND MATCHING - START
  def get_entry_vector(entry)
    @client = OpenAI::Client.new
    @response = @client.embeddings(
      parameters: {
        model: "text-embedding-ada-002",
        input: entry
      }
    )
    vector = @response.dig("data", 0, "embedding").join(", ")
    @entry.update(vector: vector)
  end

  def match_through_vectors
    # get an array with all Obstacles associated with user
    obstacles_arr = Obstacle.where(user_id: @entry.user.id).where.not(vector: nil)
    obstacles_vector_arr = obstacles_arr.pluck(:vector)
    # Map each obstacle in @obstactles_vector_arr to its vector, converted from string to array or floats
    obstacles_vector_arr_float = obstacles_vector_arr.map { |arr| arr.split(',').map(&:to_f) }
    # Iterate through each vector in the array to calculate cosine similarity against entry vector
    cosine_similarity_arr = obstacles_vector_arr_float.map { |vec| calculate_cosine_similarity(vec, @entry.vector.split(',').map(&:to_f)) }
    # Match with the highest cosine similarity as long as it is higher than .85
    if cosine_similarity_arr.max > 0.85
      highest_value_index = cosine_similarity_arr.each_index.max
      @obstacle_match = obstacles_arr[highest_value_index]
      update_entry
    else
      set_obstacle
    end
  end

  def calculate_cosine_similarity(vecA, vecB)
    return nil unless vecA.is_a? Array
    return nil unless vecB.is_a? Array
    return nil if vecA.size != vecB.size

    dot_product = 0

    vecA.zip(vecB).each do |v1i, v2i|
      dot_product += v1i * v2i
    end

    a = vecA.map { |n| n ** 2 }.reduce(:+)
    b = vecB.map { |n| n ** 2 }.reduce(:+)

    return dot_product / (Math.sqrt(a) * Math.sqrt(b))
  end

  def update_entry
    if @obstacle_match.done == true
      set_obstacle
    else
      @entry.update(obstacle_id: @obstacle_match.id)
      delete_obstacle_in_progress
    end
  end

  def set_obstacle
    @obstacle_in_progress.update(title: @summary)
    @entry.update(obstacle_id: @obstacle_in_progress.id)
    @obstacle = @obstacle_in_progress
  end
  # VECTOR ASSIGNMENT TO ENTRY AND MATCHING - ENDS
  # ENTRY/OBSTACLE ENDS

  # RECOMMENDATIONS START
  def summarize_entries_in_obstacle
    @entries_associated_to_obstacle = Entry.where(obstacle: @obstacle)
    @list_entries_associated_to_obstacle = @entries_associated_to_obstacle.map { |entry| entry.content }
    @client = OpenAI::Client.new
    @gpt_obstacle_overview = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                    content: "Create a summary of all the sentences included in the following array.
                              Write the summary from the first person perspective.
                              #{@list_entries_associated_to_obstacle}" }],
        temperature: 0.1
      }
    )
    @gpt_obstacle_overview_content = @gpt_obstacle_overview["choices"][0]["message"]["content"]
    @obstacle.update(overview: @gpt_obstacle_overview_content)
  end

  def get_recommendations
    Recommendation.where(obstacle: @obstacle).destroy_all
    @client = OpenAI::Client.new
    @gpt_recommendations = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                    content: "For the following entry, which of the following 4 techniques
                              could be applied? (1-Reframing, 2-Compassion, 3-Feel Emotions,
                              4-Visualization). Only return the techniques that are highly applicable.
                              Do not include any additional information.
                              #{@gpt_obstacle_overview_content}" }],
        temperature: 0.1
      }
    )
    @gpt_recommendations_content = @gpt_recommendations["choices"][0]["message"]["content"]
    apply_tactics
  end

  def apply_tactics
    apply_tactic("Reframing") if @gpt_recommendations_content.include?("Reframing")
    apply_tactic("Compassion") if @gpt_recommendations_content.include?("Compassion")
    apply_tactic("Feel Emotions") if @gpt_recommendations_content.include?("Emotions")
    apply_tactic("Visualization") if @gpt_recommendations_content.include?("Visualization")
  end

  def apply_tactic(tactic)
    @client = OpenAI::Client.new
    @gpt_reframing_recommendation = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                    content: "Considering 4 tactics: Reframing, Compassion, Feel Emotions and Visualization.
                              How could I apply #{tactic} to the following situation:
                              #{@gpt_obstacle_overview_content}" }],
        temperature: 0.1
      }
    )
    @reframing_recommendation_content = @gpt_reframing_recommendation["choices"][0]["message"]["content"]
    Recommendation.create(content: @reframing_recommendation_content, category: tactic, obstacle: @obstacle)
  end
  # RECOMMENDATIONS END

  # VECTOR ASSIGNMENT TO OBSTACLE - START
  def get_obstacle_vector
    @client = OpenAI::Client.new
    @response = @client.embeddings(
      parameters: {
        model: "text-embedding-ada-002",
        input: @obstacle.overview
      }
    )
    vector = @response.dig("data", 0, "embedding").join(", ")
    @obstacle.update(vector: vector)
  end
  # VECTOR ASSIGNMENT TO OBSTACLE - END



  def obstacle_status_completed
    @obstacle.update(status: "completed")
  end
end
