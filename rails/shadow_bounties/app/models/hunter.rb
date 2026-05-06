

class Hunter < ApplicationRecord
  has_many :missions, dependent: :destroy
  has_many :bounties, through: :missions

  validates :alias, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["alias", "created_at", "id", "rank", "region", "updated_at"]
  end
end