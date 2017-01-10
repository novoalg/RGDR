class AddEventsAdoptFosterDonateToStaticPages < ActiveRecord::Migration[5.0]
  def change
    add_column :static_pages, :events, :string
    add_column :static_pages, :adopt, :string
    add_column :static_pages, :foster, :string
    add_column :static_pages, :donate, :string
  end
end
