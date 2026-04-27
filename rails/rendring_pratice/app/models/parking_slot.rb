class ParkingSlot < ApplicationRecord
  has_many :parking_sessions, dependent: :destroy

  validates :slot_number, presence: true, uniqueness: true
  validates :status, presence: true

  # Set default before validations run.
  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= "free"
  end
end
