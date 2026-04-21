class PraticeUser < ApplicationRecord
  #1
  validates :name, presence: true, length: { minimum:  3 }
  validates :email, presence: true,uniqueness:true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, confirmation: true
  validates :password_confirmation, presence: true

  #2
  validates :phone, format: { with: /\A[0-9]{10}\z/ }, allow_nil: true
  validates :bio, length: {minimum:20}, allow_blank: true

  #3
  validates :admin_code, presence: true, if: :is_admin

  #4
  with_options if: :is_verified do
    validates :verified_at, presence: true
    validates :verification_token, presence: true
  end

  #5
  validates :username_no_spaces

  def username_no_spaces
    if username.present? && username.include?(" ")
      errors.add(:username, "cannot contain spaces")
    end
  end

  #6
  validate_with EmailDomainValidator

  #7
  validates :terms_accepted, acceptance: true , on: :signup
  #8
  validates :age, numericality: { greater_than_or_equal_to: 18, message: "must be at least 18"}, strict: true


end