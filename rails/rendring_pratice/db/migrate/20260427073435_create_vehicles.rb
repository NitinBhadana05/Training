class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.string :number
      t.string :type

      t.timestamps
    end
  end
end
