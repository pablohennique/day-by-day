class GenerateObstaclesJob < ApplicationJob
  queue_as :default

  def perform(entry)
    @entry = entry
    turn_to_summary(@entry.content)
    match_summary(@entry.content)
    if @match.include?("fs") || @match.include?("false")
      create_obstacle
    else
      update_entry
    end
    summarize_entries_in_obstacle
    get_recommendations
  end

  private

  # OBSTACLES STARTS
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
                              Include proper nouns and use maximum
                              7 words: #{entry}" }],
        temperature: 0.1
      }
    )
  end

  def match_summary(entry)
    # @obstacles_titles_arr = Obstacle.pluck(:title)
    @obstacles_titles_arr = Obstacle.all.map { |obstacle| "#{obstacle.id} - #{obstacle.title}" }

    gpt_match_summary(entry)
    @match = @gpt_match["choices"][0]["message"]["content"]
    @match.chop! if @match.last == "."
    @match.downcase! if @match == "False"
    @match.delete!("'Potential match: '\"")
  end

  def gpt_match_summary(entry)
    @client = OpenAI::Client.new
    @gpt_match = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                     content: "I'm attempting to match life situations that might be related to each other. These situations are separate entries in a user's journal.
                     Indicate if there is a potential match between the New Entry and the Existing Entries Array.
                     If there is a potential match, return the id associated to the Existing Entries Array where the match might exist. Do not provide any additional explanation.
                     If no relationship is found, return 'false'.
                     New Entry:'#{entry}'
                     Existing Entries Array: '#{@obstacles_titles_arr}'"}],
        temperature: 0.3
      }
    )
  end

  def create_obstacle
    @obstacle = Obstacle.create(title: @summary, user_id: @entry.user_id)
    @entry.update(obstacle_id: @obstacle.id)
  end

  def update_entry
    @match.to_i
    @obstacle = Obstacle.find_by(id: @match)
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
end
