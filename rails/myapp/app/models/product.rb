class Product < ApplicationRecord
  validates :price, numericality: { greater_than: 0, message: "Price must be greater than zero" }, strict: true
  validates :stock, numericality: { only_integer: true }

  before_save :check_price
  after_create :product_added
  before_destroy :block_if_stock

  def check_price
    if price <= 0
      errors.add(:price, "must be greater than 0")
      throw(:abort)
    end
  end

  def product_added
    puts "Product added"
  end

  def block_if_stock
    if stock > 0
      errors.add(:base, "Cannot delete product with stock")
      throw(:abort)
    end
  end

  
end
