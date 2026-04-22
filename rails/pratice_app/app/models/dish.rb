class Dish < ApplicationRecord
  has_many :dish_ingredients
  has_many :ingredients, through: :dish_ingredients

  has_many :orders

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  
  scope :available, -> { where(:available => true)}
 
end
