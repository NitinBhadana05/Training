class AssociateUser < ApplicationRecord

#association Limit and remove callback
  has_many :orders, dependent: :destroy,
  before_add: :check_order_limit,
  before_remove: :log_remove

  def check_order_limit
    if orders.count >= 5
    errors.add(:base, "You can't have more than 5 orders")
      throw :abort
    end
    puts "Order #{order.name} added"
  end

  def log_remove
    puts "Order #{order.name} removed"
  end

#suppress save
  before_save :block_invalid_name

  def block_invalid_name
    if name == "Blocked"
      errors.add(:name, "Blocked users are not allowed")
      throw :abort
    end
  end

#halting save
  before_save :first_callback
  before_save :second_callback

  def first_callback
    puts "First callback"
    if name == "Stop"
      throw :abort
    end
  end

  def second_callback
    puts "Second callback"
  end
  
#Transaction callbacks
  after_commit :log_commit
  after_rollback :log_rollback

  def log_commit
    puts "Transaction committed"
  end

  def log_rollback
    puts "Transaction rolled back"
  end


#alias callbacks
  after_create_commit :notify_user
  before_destroy :prevent_delete_if_orders

  def notify_user
    puts "User created"
  end

  def prevent_delete_if_orders
    if orders.exists?
      errors.add(:base, "Cannot delete user with orders")
      throw :abort
    end
  end

 
# CALLBACK OBJECT
  before_save LoggerCallback

end
