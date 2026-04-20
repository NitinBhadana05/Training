class AddUserRefToPratice < ActiveRecord::Migration[8.1]
  def change
    add_reference :pratices, :user, null: false, foreign_key: true
  end
end
