class EntriesController < ApplicationController
  def index
    @entries = Entry.where(user_id: current_user)
    @rand_gratefulness = Gratefulness.all.sample
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

      # create obstacle (if non-positive)
      if @sentiment == "Non-Positive"
        @obstacle = Obstacle.create(title: @summary)
      else
        @obstacle = Obstacle.find(title: @summary)
        @entry.obstacle_id = @obstacle.id
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

  # def match_summary
  #   gpt_match_summary
  #   @match = @gpt_match["choices"][0]["message"]["content"]
  # end

  # def gpt_match_summary
  #   @client = OpenAI::Client.new
  #   @gpt_match = @client.chat(
  #     parameters: {
  #       model: "gpt-3.5-turbo",
  #       messages: [{ role: "user",
  #         content: "Does the entry match any of the sentences below?
  #                   If it does, return only the sentence.
  #                   If it don't, return 'false':
  #                   '#{params[:entry][:content]}' #{@summaries}" }],
  #       temperature: 0.1
  #     }
  #   )
  # end

  def turn_to_summary
    gpt_summary_entry
    @summaries = []
    @summary = @gpt_summary["choices"][0]["message"]["content"]
    @summary.chop! if @summary.last == "."
    @entry.summary = @summary
    @summaries << @summary
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
