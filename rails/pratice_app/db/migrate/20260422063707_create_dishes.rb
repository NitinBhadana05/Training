class CreateDishes < ActiveRecord::Migration[8.1]
  def change
    create_table :dishes do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.boolean :available, default: true, null: false

      t.timestamps
    end
  end
end
