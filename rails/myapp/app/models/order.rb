class Order < ApplicationRecord
  validates :status, inclusion: { in: %w[pending shipped delivered] }
  validates :payment_method, exclusion: { in: %w[bitcoin] }
  validates :paid_at, presence: true, if: :paid?

  with_options if: -> { status == "shipped" } do
  validates :shipped_at, presence: true
  validates :tracking_id, presence: true
  end

  def paid?
    status == "paid"
  end
end
