class ChangeColumnEntryObstacleTrue < ActiveRecord::Migration[7.0]
  def change
    change_column_null :entries, :obstacle_id, true
  end
end
