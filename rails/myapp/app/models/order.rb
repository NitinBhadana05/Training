class Order < ApplicationRecord
  validates :status, inclusion: { in: %w[pending shipped delivered] }
  validates :payment_method, exclusion: { in: %w[bitcoin] }
end
