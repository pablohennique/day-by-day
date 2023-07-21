class AddVectorToObstacles < ActiveRecord::Migration[7.0]
  def change
    add_column :obstacles, :vector, :string
  end
end
