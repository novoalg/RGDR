class AddHierarchyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :hierarchy, :integer
  end
end
