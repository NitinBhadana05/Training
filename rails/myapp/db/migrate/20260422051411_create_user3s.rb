class CreateUser3s < ActiveRecord::Migration[8.1]
  def change
    create_table :user3s do |t|
      t.string :name
      t.integer :orders_count

      t.timestamps
    end
  end
end
