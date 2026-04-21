class User < ApplicationRecord
  has_one :profile
  has_many :addresses
  validates_associated :addresses
  validate :username_no_spaces

  def username_no_spaces
    if username.present? && username.include?(" ")
      errors.add(:username, "cannot contain spaces")
    end
  end
  validates :name, presence: true
  validates :middle_name, absence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, presence: true, on: :create
  validates :password, confirmation: true
  validates_each :name do |record, attr, value|
      if value =~ /\d/
        record.errors.add(attr, "cannot contain numbers")
      end
    end

  validates_with AgeValidator
  validates_with EmailDomainValidator
end
