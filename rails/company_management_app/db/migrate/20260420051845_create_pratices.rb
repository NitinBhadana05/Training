class CreatePratices < ActiveRecord::Migration[8.1]
  def change
    create_table :pratices do |t|
      t.string :name
      t.string :addres
      t.string :contect
      t.string :dob

      t.timestamps
    end
  end
end
