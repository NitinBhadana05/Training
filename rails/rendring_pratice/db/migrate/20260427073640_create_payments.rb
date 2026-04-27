class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :parking_session, null: false, foreign_key: true
      t.decimal :amount
      t.string :payment_status
      t.datetime :paid_at

      t.timestamps
    end
  end
end
