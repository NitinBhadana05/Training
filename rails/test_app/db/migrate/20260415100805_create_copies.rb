class CreateCopies < ActiveRecord::Migration[8.1]
  def change
    create_table :copies do |t|
      t.references :book, null: false, foreign_key: true
      t.string :barcode
      t.string :status
      t.string :shelf_location
      t.decimal :price

      t.timestamps
    end
  end
end
