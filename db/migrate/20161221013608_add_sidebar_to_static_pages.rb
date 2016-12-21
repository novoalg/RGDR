class AddSidebarToStaticPages < ActiveRecord::Migration[5.0]
  def change
    add_column :static_pages, :sidebar, :string
  end
end
