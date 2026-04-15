class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :role
      t.string :phone
      t.text :address
      t.boolean :active

      t.timestamps
    end
  end
end
