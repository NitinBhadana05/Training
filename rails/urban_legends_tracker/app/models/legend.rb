# app/models/legend.rb
class Legend < ApplicationRecord
  validates :title, presence: true
  validates :description, length: { minimum: 10 }
  validates :credibility_score, inclusion: { in: 1..10 }
end