class CreateImages < ActiveRecord::Migration[8.1]
  def change
    create_table :images do |t|
      t.string :url

      t.timestamps
    end
  end
end
