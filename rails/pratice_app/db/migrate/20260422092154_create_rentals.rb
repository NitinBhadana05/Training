class CreateRentals < ActiveRecord::Migration[8.1]
  def change
    create_table :rentals do |t|
      t.references :car, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.date :return_date
      
      t.decimal :total_price, precision: 10, scale: 2
      t.string :status

      t.timestamps
    end
  end
end
