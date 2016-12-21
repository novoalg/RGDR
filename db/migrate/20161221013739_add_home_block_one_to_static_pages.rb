class AddHomeBlockOneToStaticPages < ActiveRecord::Migration[5.0]
  def change
    add_column :static_pages, :home_block_one, :string
  end
end
