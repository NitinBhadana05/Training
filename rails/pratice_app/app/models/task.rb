class Task < ApplicationRecord
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: ["finished", "not finished"] }
end
