class Product < ApplicationRecord
  validates :price, numericality: { greater_than: 0, message: "Price must be greater than zero" }, strict: true
  validates :stock, numericality: { only_integer: true }
  
end
