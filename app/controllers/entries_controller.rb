class EntriesController < ApplicationController
  def index
    @entries = Entry.where(user_id: current_user).order(date: :desc).order(id: :desc)

    # Entries - Per months
    @entries_by_months = @entries
                         .group_by { |entry_month| entry_month.date.month }
                         .map { |month, entries| [month, entries.sort_by { |entry| [entry.date, entry.id] }.reverse] }
                        #  .reverse
                         .to_h

    # Gratefulness
    @rand_gratefulness = Gratefulness.where(user_id: current_user).sample
    # Good memory
    @good_memory = @entries.where(sentiment: "Positive").sample

    # Search
    if !params[:To].nil? && params[:To].split[0].present? && params[:To].split[2].present?
      search_by_date
    elsif !params[:To].nil? && params[:To].split[0].present? && !params[:To].split[2].present?
      @from_date = params[:To].split[0]
      @entries = @entries.where(date: @from_date)
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def new
    @entry = Entry.new
  end

  def create

    respond_to do |format|
      format.html
      format.json
    end
    @entry = Entry.new(rich_body: params[:entry][:rich_body], user: current_user, date: Date.today)
    @entry.content = @entry.rich_body.body.to_plain_text
    if @entry.save
      # If we get an error for sentiment analysis rerun it
      begin
        sentiment_analysis(@entry.content)
      rescue
        sentiment_analysis(@entry.content)
      end

      if @entry.sentiment == "Positive"
        begin
          turn_to_gratefulness(@entry.content)
        rescue
          turn_to_gratefulness(@entry.content)
        end
      elsif @entry.sentiment != "Positive"
        obstacle_in_progress = Obstacle.new(user_id: current_user.id, title: 'Placeholder', status: "started")
        obstacle_in_progress.save
        GenerateObstaclesJob.perform_later(@entry, obstacle_in_progress)
      end
      redirect_to entries_path, notice: "Your entry is saved."
    else
      render :new, status: 422
    end
  end

  def edit
    @entry = Entry.find(params[:id])
    # unless @entry.obstacle_id.nil?
    #   ob_id = @entry.obstacle_id
    #   @obstacle = Obstacle.find(ob_id)
    # end
  end

  def update
    @entry = Entry.find(params[:id])
    @entry.update(content: params[:entry][:content])
    redirect_to entries_path, notice: "Your entry is saved."
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    obstacle = Obstacle.find(@entry.obstacle_id)
    entries = Entry.where(user_id: current_user.id)
    entries_associated_with_obstacle = entries.select { |entry| entry.obstacle == obstacle }

    obstacle.destroy if entries_associated_with_obstacle.empty?

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
                              the following entry: #{entry}" }],
        temperature: 0.1
      }
    )
  end
  # GRATEFULNESS ENDS
end
