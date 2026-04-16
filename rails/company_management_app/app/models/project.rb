class Project < ApplicationRecord
  has_many :assigns
  has_many :employees, through: :assigns

  validates :name, presence: true
  validate :start_at_before_end_at

  def start_at_before_end_at
    if start_at.present? && end_at.present? && start_at > end_at
      errors.add(:end_at, "must be after start_at")
    end
  end
end
