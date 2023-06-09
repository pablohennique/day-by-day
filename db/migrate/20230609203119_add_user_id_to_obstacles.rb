class AddUserIdToObstacles < ActiveRecord::Migration[7.0]
  def change
    add_reference :obstacles, :user, null: false, foreign_key: true
  end
end
