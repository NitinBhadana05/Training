class Profile < ApplicationRecord
  validates :bio,
            length: { minimum: 20 },
            allow_blank: true
end