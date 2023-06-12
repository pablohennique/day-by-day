class ObstaclesController < ApplicationController

  def index
    @obstacles = Obstacle.order('id DESC')
    @current_entries = Entry.where(user_id: current_user)

    @user_obstacles = []
    @current_entries.each do |entry|
      @user_obstacles.push(Obstacle.find(entry.obstacle_id)) if !entry.obstacle_id.nil?
    end

    @done_obstacles = []
    @user_obstacles.each do |obstacle|
      @done_obstacles.push(@user_obstacles.select { |obstacle| obstacle.done?})
    end

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
