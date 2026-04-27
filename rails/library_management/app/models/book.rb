class Book < ApplicationRecord
  STANDARD_RENTAL_DAYS = 7

  has_many :issues, dependent: :restrict_with_exception

  before_validation :set_default_inventory

  validates :title, :author, :isbn, :category, :description, presence: true
  validates :isbn, uniqueness: true
  validates :total_copies, :available_copies, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :daily_rent, :purchase_price, numericality: { greater_than_or_equal_to: 0 }
  validate :available_copies_cannot_exceed_total_copies

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:title) }

  def self.filtered(params = {})
    scope = ordered

    if params[:query].present?
      query = params[:query].strip
      scope = scope.where(
        "title ILIKE :query OR author ILIKE :query OR isbn ILIKE :query OR category ILIKE :query",
        query: "%#{query}%"
      )
    end

    scope = scope.where(category: params[:category]) if params[:category].present?
    scope = scope.where("available_copies > 0") if params[:availability] == "available"
    scope = scope.where(active: true) if params[:state] == "active"
    scope = scope.where(active: false) if params[:state] == "inactive"
    scope
  end

  def issue_to!(user:, transaction_type:, issue_date: Date.current, due_date: nil)
    with_lock do
      unless available_for_checkout?
        errors.add(:base, "Book is unavailable")
        raise ActiveRecord::RecordInvalid.new(self)
      end

      issue = issues.create!(
        user:,
        transaction_type:,
        issue_date:,
        due_date: transaction_type.to_sym == :rent ? (due_date || issue_date + STANDARD_RENTAL_DAYS.days) : nil
      )

      consume_inventory_for!(transaction_type:)
      issue
    end
  end

  def rent_to!(user:, issue_date: Date.current, due_date: nil)
    issue_to!(user:, transaction_type: :rent, issue_date:, due_date:)
  end

  def sell_to!(user:, issue_date: Date.current)
    issue_to!(user:, transaction_type: :purchase, issue_date:)
  end

  def available_for_checkout?
    active? && available_copies.positive?
  end

  def category_label
    category.presence || "General"
  end

  private
    def set_default_inventory
      self.total_copies = 1 if total_copies.blank?
      self.available_copies = total_copies if available_copies.blank?
      self.active = true if active.nil?
    end

    def available_copies_cannot_exceed_total_copies
      return if available_copies.blank? || total_copies.blank?
      return unless available_copies > total_copies

      errors.add(:available_copies, "cannot exceed total copies")
    end

    def consume_inventory_for!(transaction_type:)
      self.available_copies -= 1
      self.total_copies -= 1 if transaction_type.to_sym == :purchase
      save!
    end
end
