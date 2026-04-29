class Book < ApplicationRecord
  has_many :issues, dependent: :destroy
  has_many :users, through: :issues

  validates :title, :author, :isbn, presence: true
  validates :isbn, uniqueness: true

  before_create :set_default_availability

  def active_issue
    issues.includes(:user).find_by(return_date: nil)
  end

  private

  def set_default_availability
    self.available = true if available.nil?
  end
end
