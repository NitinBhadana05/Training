class Student < ApplicationRecord

  has_many :marks

  validates :name, :email, :age, presence: true

  before_save :capitalize_name

  def capitalize_name
    self.name = name.titleize
  end
end
