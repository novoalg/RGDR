class AddUserEntriesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :age, :integer
    add_column :users, :email, :string
    add_column :users, :address_line_one, :string
    add_column :users, :address_line_two, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :string
    add_column :users, :phone, :string
  end
end
