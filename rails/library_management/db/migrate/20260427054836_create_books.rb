class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :isbn
      t.string :category
      t.text :description
      t.integer :total_copies, null: false, default: 1
      t.integer :available_copies, null: false, default: 1
      t.decimal :daily_rent, precision: 10, scale: 2, null: false, default: 0
      t.decimal :purchase_price, precision: 10, scale: 2, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :books, :isbn, unique: true
    add_index :books, :title
    add_index :books, :author
  end
end
