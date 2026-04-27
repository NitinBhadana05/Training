class Vechial < ApplicationRecord
  has_many :parking_session

  validates :name, presence: true, uniqueness: true
  validates :type, presence: true
end
