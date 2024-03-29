class ObstaclesController < ApplicationController

  def index
    @obstacles = Obstacle.where(user_id: current_user).order('id DESC')
    @done_obstacles = @obstacles.select {|obstacle| obstacle.done?}
  end

  def show
    @obstacle = Obstacle.find(params[:id])
    @recommendations = Recommendation.where(obstacle_id: @obstacle.id)
    @entries = Entry.where(obstacle_id: @obstacle.id)
  end

  def done
    @obstacle = Obstacle.find(params[:id])
    @obstacle.done? ? @obstacle.update(done: false) : @obstacle.update(done: true)
    redirect_to obstacles_path
  end

  def get_obstacle_status
    @status = current_user.obstacles.last.status
    respond_to do |format|
      format.text { render partial: "get_obstacle_status", locals: { status: @status }, formats: :html }
    end
  end

  def render_completed_obstacle_card
    @obstacle = current_user.obstacles.last
    respond_to do |format|
      format.text { render partial: "obstacle_card", locals: { obstacle: @obstacle }, formats: :html }
    end
  end
end
