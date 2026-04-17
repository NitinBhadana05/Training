class CreateUser < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email
      t.integer :age, default: 1

      t.timestamps
    end
  end
end
