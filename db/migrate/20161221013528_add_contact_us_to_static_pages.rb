class AddContactUsToStaticPages < ActiveRecord::Migration[5.0]
  def change
    add_column :static_pages, :contact_us, :string
  end
end
