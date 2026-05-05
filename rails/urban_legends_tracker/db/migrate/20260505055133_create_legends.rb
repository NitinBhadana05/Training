class CreateLegends < ActiveRecord::Migration[8.1]
  def change
    create_table :legends do |t|
      t.string :title
      t.text :description
      t.string :location
      t.integer :credibility_score

      t.timestamps
    end
  end
end
