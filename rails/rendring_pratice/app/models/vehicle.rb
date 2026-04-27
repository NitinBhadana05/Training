class Vehicle < ApplicationRecord
  has_many :parking_sessions, dependent: :destroy

  validates :vehicle_number, presence: true, uniqueness: true
  validates :vehicle_type, presence: true
end