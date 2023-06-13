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
    @entry = Entry.new(rich_body: params[:entry][:rich_body], user: current_user, date: Date.today)
    @entry.content = @entry.rich_body.body.to_plain_text
    if @entry.save
      sentiment_analysis(@entry.content)
      if @entry.sentiment == "Positive"
        turn_to_gratefulness(@entry.content)
      elsif @entry.sentiment != "Positive"
        GenerateObstaclesJob.perform_later(@entry)
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
    @to_date = params[:To].split[2]
    @entries = @entries.where('date BETWEEN ? AND ?', @from_date, @to_date)
  end

  private

  # SENTIMENT ANALYSIS STARTS
  def sentiment_analysis(entry)
    @client = OpenAI::Client.new
    @response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                  content: "Indicate the sentiment for the following entry.
                  Permited responses: 'Positive', 'Neutral', 'Negative'
                  #{entry}" }],
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
  def turn_to_gratefulness(entry)
    gpt_gratefulness(entry)
    @gratefulness = @response["choices"][0]["message"]["content"]
    Gratefulness.create(content: @gratefulness, user_id: current_user.id)
  end

  def gpt_gratefulness(entry)
    @client = OpenAI::Client.new
    @response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
                     content: "Write a gratefulness statement of 30 words or less based on
                              the followoing entry: #{entry}" }],
        temperature: 0.1
      }
    )
  end
  # GRATEFULNESS ENDS
end
