class Course < ApplicationRecord
  has_many :enrollments
  has_many :students, through: :enrollments
#habtm
  has_and_belongs_to_many :students
end
