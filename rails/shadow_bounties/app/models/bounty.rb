
class Bounty < ApplicationRecord
  has_many :missions, dependent: :destroy
  has_many :hunters, through: :missions

  mount_uploader :poster_image, ImageUploader

  validates :target_name, :threat_level, :reward_amount, presence: true
  validates :status, presence: true, inclusion: { in: ["open", "captured", "dead"] }

  def self.ransackable_attributes(auth_object = nil)
    [
      "created_at",
      "id",
      "last_seen",
      "reward_amount",
      "status",
      "target_name",
      "threat_level",
      "updated_at"
    ]
  end
end