class Bill < ApplicationRecord
  belongs_to :user
  belongs_to :issue

  enum :status, { pending: 0, paid: 1 }, default: :pending, validate: true

  before_validation :sync_paid_on

  validates :billed_on, presence: true
  validates :rent_amount, :late_fine, :total_amount, numericality: { greater_than_or_equal_to: 0 }

  scope :recent_first, -> { includes(:issue, :user).order(created_at: :desc) }

  def self.filtered(params = {})
    scope = recent_first
    scope = scope.where(status: params[:status]) if params[:status].present?
    scope = scope.where(user_id: params[:user_id]) if params[:user_id].present?
    scope
  end

  def mark_paid!
    update!(status: :paid, paid_on: Date.current)
  end

  private
    def sync_paid_on
      self.paid_on = Date.current if paid? && paid_on.blank?
      self.paid_on = nil if pending?
    end
end
