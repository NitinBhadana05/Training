class Borrow < ApplicationRecord
  # relations with user and copy
  belongs_to :user
  belongs_to :copy

  # status must be issued, returned, or late
  validates :status, inclusion: { in: %w[issued returned late] }

  # custom validation for date check
  validate :due_date_after_issue

  
  # due date must be after issue date
  def due_date_after_issue
    if due_at && issued_at && due_at < issued_at
      errors.add(:due_at, "must be after issue date")
    end
  end

  # callbacks for setting time and updating copy status
  before_create :set_issue_time
  after_create :mark_copy_unavailable

  
  # set issue time before saving
  def set_issue_time
    self.issued_at = Time.now
  end

  # mark copy as issued after borrow
  def mark_copy_unavailable
    copy.update(status: "issued")
  end
end