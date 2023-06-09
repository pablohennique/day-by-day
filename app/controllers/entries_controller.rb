class EntriesController < ApplicationController
  def index
    @rand_gratefulness = Gratefulness.all.sample
    @entries = Entry.where(user_id: current_user)
    search_by_date if params[:from_date].present? && params[:to_date].present?
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
      # create gratefulness
      turn_to_gratefulness if @sentiment == "Positive"

      # create summary
      turn_to_summary

      # match summary together
      match_summary

      # create obstacle (if non-positive and no match)
      # add entry to obstacle (if non-positive and match)
      if @sentiment == "Non-Positive" && @match == "false"
        @obstacle = Obstacle.create(title: @summary)
        @entry.update(obstacle_id: @obstacle.id)
      elsif @sentiment == "Non-Positive"
        @obstacle = Obstacle.find_by(title: @match)
        @entry.update(obstacle_id: @obstacle.id)
      else
        @entry.update(obstacle_id: nil)
      end
      redirect_to entries_path
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
    @from_date = params[:from_date]
    @to_date = params[:to_date]
    @entries = @entries.where('date BETWEEN ? AND ?', @from_date, @to_date)
  end

  private

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

  def turn_to_gratefulness
    gpt_gratefulness
    @gratefulness = @response["choices"][0]["message"]["content"]
    Gratefulness.create(content: @gratefulness, user_id: current_user)
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
        # max_tokens: 30
      }
    )
  end

  def match_summary
    @obstacles = Obstacle.all
    @obstacles_list = @obstacles.map { | obstacle | "#{obstacle.title}" }
    gpt_match_summary
    @match = @gpt_match["choices"][0]["message"]["content"]
    @match.chop! if @match.last == "."
    @match.downcase! if @match == "False"
  end

  def gpt_match_summary
    @client = OpenAI::Client.new
    @gpt_match = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
          content: "Does the entry '#{params[:entry][:content]}' talk about the same subject as one of the sentences below?
                    If it does, return only the sentence, if not return 'false'.
                    #{@obstacles_list}" }],
        temperature: 0.3
      }
    )
  end

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
          content: "Summaries like a title, this entry
                    with proper nouns in maximum
                    7 words: #{params[:entry][:content]}" }],
        temperature: 0.1
      }
    )
  end
end
