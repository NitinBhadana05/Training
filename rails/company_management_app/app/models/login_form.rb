class LoginForm
  include ActiveModel::Model
  attr_accessor :email, :password

  validates :email, :password, presence: true
  validates :password, length: { minimum: 6 }
end