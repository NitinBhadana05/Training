class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :license_number
      t.index :license_number, unique: true
      t.timestamps
    end
  end
end
