class User < ApplicationRecord
  validates :phone, format: { with: /\A\d{10}\z/ }, allow_nil: true

  validates :phone, presence: true, if: -> { is_verified && is_active }
end 