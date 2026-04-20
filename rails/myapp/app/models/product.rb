class Product < ApplicationRecord
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { only_integer: true }
end
