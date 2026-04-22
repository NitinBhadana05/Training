class User < ApplicationRecord
 
  has_many :orders2, dependent: :destroy,
           before_add: :limit_orders

  # Scoped association
  has_many :active_orders, -> { where(status: "active") }, class_name: "Order2"

  def limit_orders(order)
    if orders.count >= 5
      errors.add(:base, "Max 5 orders allowed")
      throw(:abort)
    end
    puts "Order #{order.name} added"
  end
end