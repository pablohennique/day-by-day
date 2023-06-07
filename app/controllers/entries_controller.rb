class EntriesController < ApplicationController
  def index
    @entries = Entry.where(user_id: current_user)
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
      turn_to_gratefulness if @sentiment == "Positive"
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
