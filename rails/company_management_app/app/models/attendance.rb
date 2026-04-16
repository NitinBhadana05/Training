class Attendance < ApplicationRecord
  belongs_to :employee

  validates :employee_id, uniqueness: { scope: :attendance_date }
  

  validate :check_in_before_check_out
  
  def check_in_before_check_out
    if check_in && check_out && check_in > check_out
      errors.add(:check_in, "cannot be after check_out")
    end
  end
end