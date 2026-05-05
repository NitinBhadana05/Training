# app/models/legend.rb
class Legend < ApplicationRecord
  mount_uploader :cover_image, CoverImageUploader

  validates :title, presence: true
  validates :description, length: { minimum: 10 }
  validates :credibility_score, inclusion: { in: 1..10 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[cover_image created_at credibility_score description id location title updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
