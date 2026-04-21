class CreatePraticeUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :pratice_users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :phone
      t.text :bio
      t.string :admin_code
      t.boolean :is_admin
      t.boolean :is_verified
      t.datetime :verified_at
      t.string :verification_token
      t.string :username
      t.boolean :terms_accepted
      t.integer :age

      t.timestamps
    end
  end
end
