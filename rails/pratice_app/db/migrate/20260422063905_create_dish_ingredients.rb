class CreateDishIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :dish_ingredients do |t|
      t.references :dish, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.integer :quantity_required

      t.timestamps
    end
  end
end
