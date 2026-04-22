class Order < ApplicationRecord
  belongs_to :dish
  enum status: { pending: 0, completed: 1, cancelled: 2 }

  #validations
  validates :quantity, presence:true, numericality: { greater_than: 0 }
  validates :status, :dish, presence: true

  #callbacks
  before_create :check_ingredients_stock
  before_save :calculate_total_price
  after_create :deduct_ingredients_stock
  after_update :restore_stock_if_cancelled

  #methods
  private
  def check_ingredients_stock
    dish.dish_ingredients.each do |ingredient|
      require = ingredient.quantity_required * quantity
      if ingredient.ingredient.stock < require
        errors.add(:base, "Not enough stock for #{ingredient.ingredient.name} in stock")
        throw(:abort)
      end
    end
  end

  def calculate_total_price
    self.total_price = quantity * dish.price
  end

  def deduct_ingredients_stock
    dish.dish_ingredients.each do |di|
      required = di.quantity_required * quantity
      ingredient = di.ingredient

      ingredient.update!(stock: ingredient.stock - required)
    end     
  end

  def restore_stock_if_cancelled
    return unless saved_change_to_status? && cancelled?
    
    dish.dish_ingredients.each do |di|
      required = di.quantity_required * quantity
      ingredient = di.ingredient
      ingredient.update!(stock: ingredient.stock + required)
    end
  end  
end

