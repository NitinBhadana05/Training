class NewUser < ApplicationRecord
  belongs_to :role
  
  validates :name, :email, presence: true
  validates :password, presence: true, length: { minimum: 6 }
end
