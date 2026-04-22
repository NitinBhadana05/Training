class Car < ApplicationRecord
  has_many :rentals

  validates :name, presence: true
  validates :price_per_day, presence: true, numericality: { greater_than: 0 }

  enum :status,{ available: "available", rented: "rented", maintenance: "maintenance" }

  scope :available, -> { where(:status => "available")}
  
end
