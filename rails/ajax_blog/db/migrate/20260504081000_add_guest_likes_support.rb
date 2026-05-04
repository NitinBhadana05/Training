class AddGuestLikesSupport < ActiveRecord::Migration[8.1]
  def change
    add_column :likes, :guest_token, :string
    change_column_null :likes, :user_id, true

    add_index :likes, [:post_id, :guest_token], unique: true, where: "guest_token IS NOT NULL"
    add_index :likes, [:post_id, :user_id], unique: true, where: "user_id IS NOT NULL"
  end
end
