class GenerateObstacleJob < ApplicationJob
  queue_as :default

  def perform(entry)
    @entry = entry
    turn_to_summary
    match_summary
    p @entry.sentiment
    if @entry.sentiment == "Positive"
      turn_to_gratefulness
    elsif @entry.sentiment == "Non-Positive"
      create_obstacle if @match.include?"false"
      update_entry if @match != "false"
      summarize_entries_in_obstacle
      get_recommendations
    end
  end

  private

  def turn_to_summary
    gpt_summary_entry
    @summary = @gpt_summary["choices"][0]["message"]["content"]
    @summary.chop! if @summary.last == "."
    @entry.update(summary: @summary)
  end

  def gpt_summary_entry
    @client = OpenAI::Client.new
    @gpt_summary = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                    content: "Create a title that summarizes this entry.
                              Include proper nouns and use maximum 7 words:
                              #{@entry.content}" }],
        temperature: 0.1
      }
    )
  end

  def match_summary
    # @obstacles_list = @obstacles.map { |obstacle| "#{obstacle.title}" }
    @obstacles_overview_arr = Obstacle.pluck(:title)

    gpt_match_summary
    @match = @gpt_match["choices"][0]["message"]["content"]
    @match.chop! if @match.last == "."
    @match.downcase! if @match == "False"
    @match.delete!("\"")
  end

  def gpt_match_summary
    @client = OpenAI::Client.new
    @gpt_match = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                    content: "Is there a potential match between the Entry and
                              any of the entries in the Entries Array?
                              If there is a match, return only the sentence where the first match was found.
                              Else, return 'false'.
                              Entry:'#{@entry.content}'
                              Entries Array: #{@obstacles_overview_arr}"}],
        temperature: 0.3
      }
    )
  end

  # GRATEFULNESS STARTS
  def turn_to_gratefulness
    gpt_gratefulness
    @gratefulness = @response["choices"][0]["message"]["content"]
    Gratefulness.create(content: @gratefulness, user_id: current_user.id)
  end

  def gpt_gratefulness
    @client = OpenAI::Client.new
    @response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                      content: "Write a gratefulness statement of 30 words or less based on
                              the followoing entry: #{@entry.content}" }],
        temperature: 0.1
      }
    )
  end
  # GRATEFULNESS ENDS

  # OBSTACLES START
  def create_obstacle
    @obstacle = Obstacle.create(title: @summary, user: @entry.user)
    @entry.update(obstacle_id: @obstacle.id)
  end

  def update_entry
    @obstacle = Obstacle.find_by(title: @match)
    @entry.update(obstacle_id: @obstacle.id)
  end
  # OBSTACLE ENDS

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
    apply_reframing if @gpt_recommendations_content.include?("Reframing")
    apply_compassion if @gpt_recommendations_content.include?("Compassion")
    apply_feel_emotions if @gpt_recommendations_content.include?("Emotions")
    apply_visualization if @gpt_recommendations_content.include?("Visualization")
  end

  def apply_reframing
    @client = OpenAI::Client.new
    @gpt_reframing_recommendation = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                    content: "Considering 4 tactics: Reframing, Compassion, Feel Emotions and Visualization.
                              How could I apply Reframing to the following situation:
                              #{@gpt_obstacle_overview_content}" }],
        temperature: 0.1
      }
    )
    @reframing_recommendation_content = @gpt_reframing_recommendation["choices"][0]["message"]["content"]
    Recommendation.create(content: @reframing_recommendation_content, category: "Reframing", obstacle: @obstacle)
  end

  def apply_compassion
    @client = OpenAI::Client.new
    @gpt_compassion_recommendation = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                    content: "Considering 4 tactics: Reframing, Compassion, Feel Emotions and Visualization.
                              How could I apply Compassion to the following situation:
                              #{@gpt_obstacle_overview_content}" }],
        temperature: 0.1
      }
    )
    @compassion_recommendation_content = @gpt_compassion_recommendation["choices"][0]["message"]["content"]
    Recommendation.create(content: @compassion_recommendation_content, category: "Compassion", obstacle: @obstacle)
  end

  def apply_feel_emotions
    @client = OpenAI::Client.new
    @gpt_emotions_recommendation = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                    content: "Considering 4 tactics: Reframing, Compassion, Feel Emotions and Visualization.
                              How could I apply Feel Emotions to the following situation:
                              #{@gpt_obstacle_overview_content}" }],
        temperature: 0.1
      }
    )
    @emotions_recommendation_content = @gpt_emotions_recommendation["choices"][0]["message"]["content"]
    Recommendation.create(content: @emotions_recommendation_content, category: "Feel Emotions", obstacle: @obstacle)
  end

  def apply_visualization
    @client = OpenAI::Client.new
    @gpt_visualization_recommendation = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                    content: "Considering 4 tactics: Reframing, Compassion, Feel Emotions and Visualization.
                              How could I apply Visualization to the following situation:
                              #{@gpt_obstacle_overview_content}" }],
        temperature: 0.1
      }
    )
    @visualization_recommendation_content = @gpt_visualization_recommendation["choices"][0]["message"]["content"]
    Recommendation.create(content: @visualization_recommendation_content, category: "Visualization", obstacle: @obstacle)
  end
  # RECOMMENDATIONS END
end
