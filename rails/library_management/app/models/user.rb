class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :bills, dependent: :destroy

  enum :role, { user: 0, admin: 1 }, default: :user, validate: true

  normalizes :full_name, with: ->(name) { name.strip.squish }
  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :full_name, presence: true
  validates :email_address, presence: true, uniqueness: true

  scope :ordered, -> { order(:role, :full_name) }

  def self.search(query)
    return ordered if query.blank?

    where(
      "full_name ILIKE :query OR email_address ILIKE :query",
      query: "%#{query.strip}%"
    ).ordered
  end
end
