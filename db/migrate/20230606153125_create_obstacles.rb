class CreateObstacles < ActiveRecord::Migration[7.0]
  def change
    create_table :obstacles do |t|
      t.string :title
      t.text :description
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
