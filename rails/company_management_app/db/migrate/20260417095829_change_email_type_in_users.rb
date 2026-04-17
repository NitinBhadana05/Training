class ChangeEmailTypeInUsers < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :email, :text
  end
end
