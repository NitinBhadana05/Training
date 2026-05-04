class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :issue_date, presence: true
  validates :transaction_type, inclusion: { in: %w[rent buy] }
  validate :book_must_be_available, on: :create
  before_validation :set_default_issue_date
  before_validation :set_billing_amounts, on: :create

  def book_must_be_available
    errors.add(:book, "is already issued") unless book.available
  end

  after_create :mark_book_unavailable
  after_update :mark_book_available, if: :returned?

  def returned?
    rent? && return_date.present?
  end

  def rent?
    transaction_type == "rent"
  end

  def buy?
    transaction_type == "buy"
  end

  private

  def set_default_issue_date
    self.issue_date ||= Date.current
  end

  def set_billing_amounts
    return unless book && user

    self.amount = buy? ? book.purchase_price : book.rental_fee
    self.previous_balance = user.issues.sum(:amount)
    self.balance_after = previous_balance + amount
  end

  def mark_book_unavailable
    book.update(available: false)
  end

  def mark_book_available
    book.update(available: true)
  end
end
