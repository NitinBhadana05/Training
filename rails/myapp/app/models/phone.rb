class User < ApplicationRecord
  validates :phone,
            format: { with: /\A\d{10}\z/ },
            allow_nil: true
end