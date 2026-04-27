class ParkingSlot < ApplicationRecord
  has_many :parking_session

  validates :slot_number, presence: true, uniqueness: true
  validates :status, presence: true

  # default status
  before_create :set_default_status

  private

  def set_default_status
    self.status ||= "free"
  end
end
