class Book < ApplicationRecord
  has_many :issues, dependent: :destroy
  has_many :users, through: :issues

  validates :title, :author, :isbn, presence: true
  validates :isbn, uniqueness: true

  before_create :set_default_availability

  def active_issue
    issues.includes(:user).find_by(transaction_type: "rent", return_date: nil)
  end

  def latest_bill
    issues.includes(:user).order(created_at: :desc).first
  end

  private

  def set_default_availability
    self.available = true if available.nil?
  end
end
