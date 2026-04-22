class CreateCars < ActiveRecord::Migration[8.1]
  def change
    create_table :cars do |t|
      t.string :name
      t.string :car_type
      t.decimal :price_per_day, precision: 10, scale: 2
      t.string :status 

      t.timestamps
    end
  end
end
