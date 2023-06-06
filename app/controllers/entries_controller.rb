class EntriesController < ApplicationController

def index
  @entries = Entry.where(user_id: current_user)
end

def new
  @entry = Entry.new
end

end
