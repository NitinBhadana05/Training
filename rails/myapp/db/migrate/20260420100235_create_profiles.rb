class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.text :bio

      t.timestamps
    end
  end
end
