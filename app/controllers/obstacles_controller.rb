class ObstaclesController < ApplicationController

def index
  @obstacles = Obstacle.all
end


def show
  @obstacle = Obstacle.find(params[:id])
end

end
