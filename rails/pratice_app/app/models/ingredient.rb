class Ingredient < ApplicationRecord
  has_many :dish_ingredients
  has_many :dishes, through: :dish_ingredients

  validates :name, presence: true
  validates :stock, presence: true, numericality: { greater_then_or_equal_to:0 }

   after_update :update_dish_availability

  private

  def update_dish_availability
    dishes.each do |dish|
      if dish.ingredients.any? { |ing| ing.stock == 0 }
        dish.update(available: false)
      else
        dish.update(available: true)
      end
    end
  end
end

