class EntriesController < ApplicationController

def index
  @entries = Entry.where(user_id: current_user)
end

end
