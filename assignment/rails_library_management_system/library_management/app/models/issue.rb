class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :issue_date, presence: true
  validate :book_must_be_available, on: :create

  def book_must_be_available
    errors.add(:book, "is already issued") unless book.available
  end

  after_create :mark_book_unavailable
  after_update :mark_book_available, if: :returned?

  def returned?
    return_date.present?
  end

  private

  def mark_book_unavailable
    book.update(available: false)
  end

  def mark_book_available
    book.update(available: true)
  end
end
