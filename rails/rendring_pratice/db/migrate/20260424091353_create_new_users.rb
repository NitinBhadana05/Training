class CreateNewUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :new_users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
