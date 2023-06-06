class CreateRecommendations < ActiveRecord::Migration[7.0]
  def change
    create_table :recommendations do |t|
      t.string :title
      t.text :content
      t.references :obstacle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
