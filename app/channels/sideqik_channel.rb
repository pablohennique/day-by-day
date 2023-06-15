class SideqikChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    # user = User.find(params[:id])
    user = current_user
    stream_for user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
