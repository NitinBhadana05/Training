class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :dish, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :total_price, precision: 10, scale: 2
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
