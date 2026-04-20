class CreateAdmins < ActiveRecord::Migration[8.1]
  def change
    create_table :admins do |t|
      t.string :admin_code
      t.boolean :is_admin

      t.timestamps
    end
  end
end
