class AssociateOrder < ApplicationRecord
  belongs_to :user

  before_destroy :log_destroy

  def log_destroy
    puts "Order destroyed"
  end
end
