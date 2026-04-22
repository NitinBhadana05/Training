class DishIngredient < ApplicationRecord
  belongs_to :dish
  belongs_to :ingredient

  validates :quantity_required, presence: true, numericality: { greater_than: 0 }
end
