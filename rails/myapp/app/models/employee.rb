class Employee < ApplicationRecord
  belongs_to :manager, class_name: "Employee", optional: true
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"

end
