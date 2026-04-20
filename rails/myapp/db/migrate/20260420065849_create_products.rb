class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.decimal :price
      t.integer :stock

      t.timestamps
    end
  end
end
