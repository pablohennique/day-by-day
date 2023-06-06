class EntriesController < ApplicationController
  def index
    @entries = Entry.where(user_id: current_user)
  end

  # this method is for OPEN AI testing purposes only
  def chat_test
    @client = OpenAI::Client.new
    @response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: params[:query] }],
        temperature: 0.3
      }
    )
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(content: params[:entry][:content], user: current_user, date:Date.today)
    @entry.save
    redirect_to entries_path
  end


end
