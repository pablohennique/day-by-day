class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.text :content
      t.date :date
      t.text :title_summary
      t.string :sentiment
      t.references :user, null: false, foreign_key: true
      t.references :obstacle, null: false, foreign_key: true
      t.timestamps
    end
  end
end
