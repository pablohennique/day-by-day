class RemoveColumnDescriptionFromObstacles < ActiveRecord::Migration[7.0]
  def change
    remove_column :obstacles, :description
  end
end
