class Department < ApplicationRecord
  has_many :employees, dependent: :destroy

  validates :name, :status ,presence: true
end
