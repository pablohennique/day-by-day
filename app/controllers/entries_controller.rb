class EntriesController < ApplicationController
  def index
    @entries = Entry.where(user_id: current_user)
  end

  # this method is for OPEN AI testing purposes only
  # def chat_test
  #   @client = OpenAI::Client.new
  #   @response = @client.chat(
  #     parameters: {
  #       model: "gpt-3.5-turbo",
  #       messages: [{ role: "user", content: params[:query] }],
  #       temperature: 0.3
  #     }
  #   )
  # end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(content: params[:entry][:content], user: current_user, date: Date.today)
    @entry.save
    sentiment_analysis
    turn_to_gratefulness if @sentiment == "Positive"
    redirect_to entries_path
    raise
  end

  private

  def sentiment_analysis
    @client = OpenAI::Client.new
    @response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                     content: "Indicate if the following entry has a positive or non-positive sentiment.
                              Permited responses: 'Positive' or 'Non-Positive' #{params[:entry][:content]}" }],
        temperature: 0.3
        # max_tokens: 30
      }
    )
    @sentiment = @response["choices"][0]["message"]["content"]
    @sentiment.chop! if @sentiment.last == "."
  end

  def turn_to_gratefulness
    if params[:entry][:content].length < 30
      @gratefulness = params[:entry][:content]
    else
      gpt_gratefulness
      @gratefulness = @response["choices"][0]["message"]["content"]
    end
  end

  def gpt_gratefulness
    @client = OpenAI::Client.new
    @response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                     content: "Write the thesis statement of the following entry in the frist person:
                              #{params[:entry][:content]}" }],
        temperature: 0.1,
        max_tokens: 30
      }
    )
  end
end
