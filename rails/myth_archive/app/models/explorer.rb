class Explorer < ApplicationRecord
  has_many :artifacts, dependent: :destroy

  validates :codename, presence: true
  validates :reputation, inclusion: { in: 1..10 }

  def self.ransackable_attributes(auth_object = nil)
    ["codename", "created_at", "id", "region", "reputation", "updated_at"]
  end
end