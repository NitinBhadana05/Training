class Profile < ApplicationRecord
  belongs_to :user
  validates :bio,
            length: { minimum: 20 },
            allow_blank: true
end