class AddVectorToEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :entries, :vector, :string
  end
end
