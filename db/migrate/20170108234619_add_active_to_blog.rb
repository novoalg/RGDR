class AddActiveToBlog < ActiveRecord::Migration[5.0]
  def change
    add_column :blogs, :active, :boolean
  end
end
