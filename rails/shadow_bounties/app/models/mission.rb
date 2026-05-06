class Mission < ApplicationRecord
  belongs_to :hunter
  belongs_to :bounty
   
  validates :hunter_id, :bounty_id, presence: true
  validates :completed, inclusion: { in: [true, false] }

  def self.ransackable_attributes(auth_object = nil)
    ["completed", "created_at", "id", "notes", "updated_at"]
  end
end
