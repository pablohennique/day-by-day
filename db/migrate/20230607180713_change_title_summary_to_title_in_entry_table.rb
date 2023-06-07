class ChangeTitleSummaryToTitleInEntryTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :entries, :title_summary, :summary
  end
end
