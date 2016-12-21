class AddHelpToStaticPages < ActiveRecord::Migration[5.0]
  def change
    add_column :static_pages, :help, :string
  end
end
