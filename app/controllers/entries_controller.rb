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
      turn_to_gratefulness if @sentiment == "Positive"
      #summary_entry (entry.summary = @gpt_summary)
      #find match this existing summary
      #if (non-match with Obstacle.all) && (@sentiment == "Non-Positive"), create_obstacle(title:@response)
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


  def gpt_summary_entry
    @client = OpenAI::Client.new
    @gpt_summary = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
          content: "Write a gratefulness statement of 30 words or less based on
                   the followoing entry: #{params[:entry][:content]}" }],
        temperature: 0.1
      }
    )
  end

end
