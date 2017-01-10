class AddNeededColumnsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :name, :string
    add_column :events, :location, :string
    add_column :events, :time, :string
    add_column :events, :information, :string
    add_column :events, :special, :boolean
  end
end
