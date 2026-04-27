class Issue < ApplicationRecord
  LATE_FEE_MULTIPLIER = BigDecimal("0.50")

  belongs_to :user
  belongs_to :book
  has_one :bill, dependent: :destroy

  enum :transaction_type, { rent: 0, purchase: 1 }, default: :rent, validate: true
  enum :status, { active: 0, returned: 1, purchased: 2, overdue: 3 }, default: :active, validate: true

  before_validation :set_defaults
  before_validation :normalize_due_date
  before_validation :calculate_amounts
  after_save :sync_bill!

  validates :issue_date, presence: true
  validates :due_date, presence: true, if: :rent?
  validates :return_date, comparison: { greater_than_or_equal_to: :issue_date }, allow_nil: true
  validates :rent_amount, :late_fine, :total_amount, numericality: { greater_than_or_equal_to: 0 }

  scope :recent_first, -> { includes(:user, :book, :bill).order(created_at: :desc) }

  def self.filtered(params = {})
    scope = recent_first
    scope = scope.where(status: params[:status]) if params[:status].present?
    scope = scope.where(transaction_type: params[:transaction_type]) if params[:transaction_type].present?
    scope = scope.where(user_id: params[:user_id]) if params[:user_id].present?
    scope = scope.where(book_id: params[:book_id]) if params[:book_id].present?
    scope
  end

  def late_days(reference_date = effective_end_date)
    return 0 unless rent? && due_date.present?

    [(reference_date - due_date).to_i, 0].max
  end

  def rental_days(reference_date = effective_end_date)
    return 0 unless rent? && issue_date.present?

    [(reference_date - issue_date).to_i, 1].max
  end

  def effective_end_date
    return_date || Date.current
  end

  def returnable_by?(acting_user)
    acting_user.present? && rent? && (acting_user.admin? || acting_user == user) && !returned?
  end

  def mark_as_returned!(returned_on: Date.current)
    return if returned?

    transaction do
      update!(return_date: returned_on, status: :returned)
      book.increment!(:available_copies)
    end
  end

  def bill_status_label
    bill&.status&.capitalize || "Pending"
  end

  private
    def set_defaults
      self.issue_date ||= Date.current
      self.status ||= purchase? ? :purchased : :active
    end

    def normalize_due_date
      self.due_date = nil if purchase?
    end

    def calculate_amounts
      if purchase?
        self.rent_amount = book&.purchase_price.to_d.round(2)
        self.late_fine = 0
        self.total_amount = rent_amount
        self.status = :purchased
      else
        self.rent_amount = (book&.daily_rent.to_d * rental_days).round(2)
        self.late_fine = (late_days * late_fee_per_day).round(2)
        self.total_amount = (rent_amount + late_fine).round(2)
        self.status = if return_date.present?
          :returned
        elsif due_date.present? && Date.current > due_date
          :overdue
        else
          :active
        end
      end
    end

    def late_fee_per_day
      (book&.daily_rent.to_d * LATE_FEE_MULTIPLIER).round(2)
    end

    def sync_bill!
      bill_record = bill || build_bill(user:)
      bill_record.assign_attributes(
        billed_on: return_date || issue_date,
        rent_amount:,
        late_fine:,
        total_amount:,
        notes: bill_note
      )
      bill_record.status ||= :pending
      bill_record.save!
    end

    def bill_note
      purchase? ? "Purchased copy of #{book.title}" : "Rental billing for #{book.title}"
    end
end
