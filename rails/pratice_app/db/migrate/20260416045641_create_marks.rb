class CreateMarks < ActiveRecord::Migration[8.1]
  def change
    create_table :marks do |t|
      t.references :student, null: false, foreign_key: true
      t.string :subject
      t.integer :marks
      t.string :exam_type
      t.string :grade

      t.timestamps
    end
  end
end
