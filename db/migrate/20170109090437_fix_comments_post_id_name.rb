class FixCommentsPostIdName < ActiveRecord::Migration[5.0]
  def change
    rename_column :comments, :post_id, :blog_id
  end
end
