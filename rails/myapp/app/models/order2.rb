class Order2 < ApplicationRecord
  belongs_to :user3, counter_cache: true

  before_create :set_default_status

  def set_default_status
    self.status ||= "active"
  end
end
