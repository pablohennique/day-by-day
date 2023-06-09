class ObstaclesController < ApplicationController

  def index
    @obstacles = Obstacle.order('id DESC')
  end

  def show
    @obstacle = Obstacle.find(params[:id])
    @recommendations = Recommendation.where(obstacle_id: @obstacle.id)
    @entries = Entry.where(obstacle_id: @obstacle.id)
  end
end
