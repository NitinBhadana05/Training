class CreateOrder2s < ActiveRecord::Migration[8.1]
  def change
    create_table :order2s do |t|
      t.string :name
      t.string :status
      t.references :user3, null: false, foreign_key: true

      t.timestamps
    end
  end
end
