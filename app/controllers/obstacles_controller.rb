class ObstaclesController < ApplicationController

  def index
    @obstacles = Obstacle.where(user_id: current_user).order('id DESC')
  end

  def show
    @obstacle = Obstacle.find(params[:id])
    @recommendations = Recommendation.where(obstacle_id: @obstacle.id)
    @entries = Entry.where(obstacle_id: @obstacle.id)
  end

  def done
    @obstacle = Obstacle.find(params[:id])
    @obstacle.update(done: true)
    redirect_to obstacles_path
  end
end
