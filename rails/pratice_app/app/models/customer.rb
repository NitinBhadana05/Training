class Customer < ApplicationRecord
  has_many :rentals

  validates :name, presence: true
  validates :license_number, presence: true, uniqueness: true
end
