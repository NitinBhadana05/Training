class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :payment_method

      t.timestamps
    end
  end
end
