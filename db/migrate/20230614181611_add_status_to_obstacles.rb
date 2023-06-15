class AddStatusToObstacles < ActiveRecord::Migration[7.0]
  def change
    add_column :obstacles, :status, :integer, null: false, default: 0
  end
end
