class Rental < ApplicationRecord
  belongs_to :car
  belongs_to :customer

  has_one :fine

  validates :start_date, presence: true
  validates :end_date, presence: true 
  validate :end_date_after_start_date

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end
  enum :status, {ongoing: "ongoing", completed: "completed", cancelled: "cancelled"}

  before_create :check_car_availability
  before_create :prevent_overlapping_bookings
  before_save :calculate_total_price

  after_create :mark_car_as_rented
  after_update :handle_completion_and_fine

  private
   # Car must be available
  def check_car_availability
    if car.status != "available"
      errors.add(:base, "Car is not available")
      throw(:abort)
    end
  end

  # Prevent overlapping bookings
  def prevent_overlapping_bookings
    overlapping = Rental.where(car_id: car_id)
      .where.not(id: id)
      .where(status = "ongoing")

    if overlapping.exists?
      errors.add(:base, "Car already booked for these dates")
      throw(:abort)
    end
  end

  #  Calculate total price
  def calculate_total_price
    days = (end_date - start_date).to_i+1
    self.total_price = days * car.price_per_day
  end

  # Mark car as rented
  def mark_car_as_rented
    car.update!(status: "rented")
  end

  # Handle completion + fine
  def handle_completion_and_fine
    if saved_change_to_status? && completed?
      car.update!(status: "available")

      # Late return → fine
      if return_date.present? && return_date > end_date
        late_days = (return_date - end_date).to_i

        create_fine!(
          amount: late_days * 100, 
          reason: "Late return"
        )
      end
    end
  end

end
