class CreateIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :stock, default: 0, null: false

      t.timestamps
    end
  end
end
