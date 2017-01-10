class FixEventNameFromStaticPages < ActiveRecord::Migration[5.0]
  def change
    rename_column :static_pages, :events, :event
    add_column :static_pages, :special_event, :string
  end
end
