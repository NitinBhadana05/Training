class AddLikedToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :liked, :boolean
  end
end
