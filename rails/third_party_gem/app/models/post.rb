class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "content", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "image_attachment", "image_blob"]
  end
end
