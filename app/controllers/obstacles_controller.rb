class ObstaclesController < ApplicationController

  def index
    @obstacles = Obstacle.all
  end


  def show
    @obstacle = Obstacle.find(params[:id])
    @recommendations = Recommendation.where(obstacle_id: @obstacle.id)
  end

end
