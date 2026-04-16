class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.decimal :budget
      t.date :start_at
      t.date :end_at

      t.timestamps
    end
  end
end
