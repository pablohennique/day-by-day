class RecommendationsController < ApplicationController

def show
  @recommendation = Recommendation.find(params[:id])
  @obstacle = @recommendation.obstacle
end

end
