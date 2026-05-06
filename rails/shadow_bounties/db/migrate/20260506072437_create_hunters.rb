class CreateHunters < ActiveRecord::Migration[8.1]
  def change
    create_table :hunters do |t|
      t.string :alias
      t.string :rank
      t.string :region

      t.timestamps
    end
  end
end
