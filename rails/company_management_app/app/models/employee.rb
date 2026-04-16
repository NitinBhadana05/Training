class Employee < ApplicationRecord
  belongs_to :department

  has_many :attendances
  has_many :assigns
  has_many :projects, through: :assigns

  validates :name,:role, :department,:salary, :date_of_join, presence: true
  validates :salary, numericality: { greater_than: 0 }  
  
end