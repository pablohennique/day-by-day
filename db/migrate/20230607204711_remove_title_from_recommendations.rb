class RemoveTitleFromRecommendations < ActiveRecord::Migration[7.0]
  def change
    remove_column :recommendations, :title, :string
  end
end
