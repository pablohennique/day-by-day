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

  def show
    @entry = Entry.find(params[:id])
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(content: params[:entry][:content], user: current_user, date:Date.today)
    @entry.save
    redirect_to entries_path
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
end
