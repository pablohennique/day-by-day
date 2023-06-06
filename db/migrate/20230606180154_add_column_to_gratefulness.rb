class AddColumnToGratefulness < ActiveRecord::Migration[7.0]
  def change
    add_reference :gratefulnesses, :user, foreign_key: true
  end
end
