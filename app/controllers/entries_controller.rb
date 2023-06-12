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
      GenerateObstacleJob.perform_later(@entry)
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
end
