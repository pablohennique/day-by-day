class EntriesController < ApplicationController
  def index
    @rand_gratefulness = Gratefulness.where(user_id: current_user).sample
    @entries = Entry.where(user_id: current_user)
    @entries = Entry.order('id DESC')
    search_by_date if !params[:To].nil? && params[:To].split[0].present? && params[:To].split[2].present?
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(content: params[:entry][:content], user: current_user, date: Date.today)
    if @entry.save
      sentiment_analysis
      turn_to_summary
      match_summary
      if @sentiment == "Positive"
        turn_to_gratefulness
      elsif @sentiment == "Non-Positive"
        create_obstacle if @match == "false"
        update_entry if @match != "false"
        summarize_entries_in_obstacle
        get_recommendations
      end
      redirect_to edit_entry_path(@entry)
    else
      render :new, status: 422
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
    @entry = Entry.find(params[:id])
    @entry.update(content: params[:entry][:content])
    redirect_to entries_path
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    redirect_to entries_path
  end

  def search_by_date
    @from_date = params[:To].split[0]
    @to_date =  params[:To].split[2]
    @entries = @entries.where('date BETWEEN ? AND ?', @from_date, @to_date)
  end

  private

  # SENTIMENT ANALYSIS STARTS
  def sentiment_analysis
    @client = OpenAI::Client.new
    @response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                  content: "Indicate the sentiment for the following entry.
                              Permited responses: 'Positive', 'Non-Positive'
                              #{params[:entry][:content]}" }],
        temperature: 0.3
        # max_tokens: 30
      }
    )
    @sentiment = @response["choices"][0]["message"]["content"]
    @sentiment.chop! if @sentiment.last == "."
    @entry.update(sentiment: @sentiment)
  end
  # SENTIMENT ANALYSIS ENDS


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
                              the followoing entry: #{params[:entry][:content]}" }],
        temperature: 0.1
      }
    )
  end
  # GRATEFULNESS ENDS

  # OBSTACLES STARTS
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
                              Include proper nouns and use maximum
                              7 words: #{params[:entry][:content]}" }],
        temperature: 0.1
      }
    )
  end

  def match_summary
    @obstacles = Obstacle.all

    # @obstacles_list = @obstacles.map { |obstacle| "#{obstacle.title}" }
    @obstacles_overview_arr = @obstacles.map { |obstacle| obstacle.overview }

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
                     content: "Is there a potential match between the Entry and any of the entries in the Entries Array?
                     If there is a match, return only the sentence where the first match was found.
                     Else, return 'false'.
                     Entry:'#{params[:entry][:content]}'
                     Entries Array: #{@obstacles_overview_arr}"}],
        temperature: 0.3
      }
    )
  end

  def create_obstacle
    @obstacle = Obstacle.create(title: @summary)
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
