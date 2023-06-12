class AddOverviewToObstacles < ActiveRecord::Migration[7.0]
  def change
    add_column :obstacles, :overview, :text
  end
end
