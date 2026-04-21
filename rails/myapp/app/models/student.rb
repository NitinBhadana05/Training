class Student < ApplicationRecord
  has_many :enrollments
  has_many :courses, through: :enrollments
#habtm
  has_and_belongs_to_many :courses
end