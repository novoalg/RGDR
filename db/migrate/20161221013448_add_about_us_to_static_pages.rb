class AddAboutUsToStaticPages < ActiveRecord::Migration[5.0]
  def change
    add_column :static_pages, :about_us, :string
  end
end
