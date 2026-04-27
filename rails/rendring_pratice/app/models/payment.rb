class Payment < ApplicationRecord
  belongs_to :parking_session

  validates :payment_status, presence: true

  before_create :calculate_amount

  private

  def calculate_amount
    hours = parking_session.duration || 0

    amount = if hours <= 1
               20
             else
               20 + (hours - 1) * 10
             end

    # late night charge (12 AM - 6 AM)
    if parking_session.entry_time&.hour.to_i < 6
      amount += 15
    end

    self.amount = amount
  end
end