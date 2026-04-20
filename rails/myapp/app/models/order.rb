class Order < ApplicationRecord
  validates :status, inclusion: { in: %w[pending shipped delivered] }
  validates :payment_method, exclusion: { in: %w[bitcoin] }
  validates :paid_at, presence: true, if: :paid?

  def paid?
    status == "paid"
  end
end
