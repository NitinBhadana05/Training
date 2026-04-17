class Order < ApplicationRecord
  belongs_to :book

  # CALLBACKS
  before_validation :set_issue_date
  before_save :check_dates
  after_create :show_message

  private

  def set_issue_date
    self.issue_date ||= Date.today
  end

  def check_dates
    if return_date && issue_date && return_date < issue_date
      errors.add(:return_date, "cannot be before issue date")
      throw(:abort)
    end
  end

  def show_message
    puts "Order created for #{user}"
  end
end