class CreateGratefulnesses < ActiveRecord::Migration[7.0]
  def change
    create_table :gratefulnesses do |t|
      t.text :content

      t.timestamps
    end
  end
end
