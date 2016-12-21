class AddWoofsForHelpToStaticPage < ActiveRecord::Migration[5.0]
  def change
    add_column :static_pages, :woofs_for_help, :string
  end
end
