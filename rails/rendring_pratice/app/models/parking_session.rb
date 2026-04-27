class ParkingSession < ApplicationRecord
  belongs_to :vehicle
  belongs_to :parking_slot
  has_one :payment, dependent: :destroy

  validates :status, presence: true

  # Callbacks
  before_create :set_entry_time, :set_active_status
  before_save :calculate_duration
  after_update :generate_payment, if: :saved_change_to_exit_time?

  private

  def set_entry_time
    self.entry_time ||= Time.current
  end

  def set_active_status
    self.status ||= "active"
    parking_slot.update(status: "occupied")
  end

  def calculate_duration
    if entry_time && exit_time
      self.duration = ((exit_time - entry_time) / 1.hour).ceil
    end
  end

  def generate_payment
    return if payment.present?

    create_payment!(
      payment_status: "pending"
    )

    update_column(:status, "completed")
    parking_slot.update(status: "free")
  end
end