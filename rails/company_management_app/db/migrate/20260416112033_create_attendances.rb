class CreateAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :attendances do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :attendance_date
      t.time :check_in
      t.time :check_out

      t.timestamps
    end
  end
end
