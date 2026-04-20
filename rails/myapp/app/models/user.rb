class User < ApplicationRecord
  has_many :addresses
  validates_associated :addresses

  validates :name, presence: true
  validates :middle_name, absence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, confirmation: true
  validates_each :name do |record, attr, value|
      if value =~ /\d/
        record.errors.add(attr, "cannot contain numbers")
      end
    end

  validates_with AgeValidator
end
