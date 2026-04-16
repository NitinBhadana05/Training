class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :role
      t.references :department, null: false, foreign_key: true
      t.decimal :salary
      t.date :date_of_join

      t.timestamps
    end
  end
end
