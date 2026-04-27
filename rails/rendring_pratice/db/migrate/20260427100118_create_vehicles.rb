class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.string :vehicle_number
      t.string :vehicle_type

      t.timestamps
    end
  end
end
