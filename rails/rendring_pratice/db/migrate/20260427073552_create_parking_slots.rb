class CreateParkingSlots < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_slots do |t|
      t.string :slot_number
      t.string :status

      t.timestamps
    end
  end
end
