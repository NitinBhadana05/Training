class CreateAssociateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :associate_users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
