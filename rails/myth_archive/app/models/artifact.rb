# app/models/artifact.rb

class Artifact < ApplicationRecord
  belongs_to :explorer

  mount_uploader :image, ImageUploader

  validates :name, presence: true
  validates :danger_level, inclusion: { in: 1..10 }

  def self.ransackable_attributes(auth_object = nil)
    [
      "created_at",
      "danger_level",
      "description",
      "discovered_on",
      "id",
      "name",
      "origin_country",
      "updated_at",
      "explorer_id"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["explorer"]
  end
end