class User < ApplicationRecord
  has_many :issues, dependent: :destroy
  has_many :books, through: :issues

  has_secure_password

  attr_accessor :reset_password_token

  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  def admin?
    admin
  end

  def generate_password_reset_token!
    token = SecureRandom.urlsafe_base64(32)
    update!(
      reset_password_digest: BCrypt::Password.create(token),
      reset_password_sent_at: Time.current
    )
    self.reset_password_token = token
  end

  def password_reset_token_valid?(token)
    return false if reset_password_digest.blank? || reset_password_sent_at.blank?
    return false if reset_password_sent_at < 2.hours.ago

    BCrypt::Password.new(reset_password_digest).is_password?(token)
  end

  def clear_password_reset!
    update!(reset_password_digest: nil, reset_password_sent_at: nil)
  end
end
