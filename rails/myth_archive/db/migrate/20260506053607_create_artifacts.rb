class CreateArtifacts < ActiveRecord::Migration[8.1]
  def change
    create_table :artifacts do |t|
      t.string :name
      t.text :description
      t.string :origin_country
      t.integer :danger_level
      t.date :discovered_on
      t.string :image
      t.references :explorer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
