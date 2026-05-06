class CreateMissions < ActiveRecord::Migration[8.1]
  def change
    create_table :missions do |t|
      t.references :hunter, null: false, foreign_key: true
      t.references :bounty, null: false, foreign_key: true
      t.boolean :completed
      t.text :notes

      t.timestamps
    end
  end
end