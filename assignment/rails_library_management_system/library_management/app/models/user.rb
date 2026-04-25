class User < ApplicationRecord
    has_many :issues, dependent: :destroy
    has_many :books, through: :issues

    has_secure_password

    validates :name, presence: true, length: { minimum: 3 }
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 6 }, if: -> { password.present? }



end
