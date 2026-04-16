class CreateStudents < ActiveRecord::Migration[8.1]
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.integer :age
      t.string :course
      t.date :enroll_on
      t.boolean :actie

      t.timestamps
    end
  end
end
