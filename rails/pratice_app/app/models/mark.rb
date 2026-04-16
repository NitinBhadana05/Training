class Mark < ApplicationRecord
  belongs_to :student

  validates :subject, :marks, :exam_type, :grade, presence: true
  validates :marks, numericality: { only_integer: true }
end
