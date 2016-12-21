class AddUserIdAndContentToBlog < ActiveRecord::Migration[5.0]
  def change
    add_column :blogs, :user_id, :integer
    add_column :blogs, :content, :string
  end
end
