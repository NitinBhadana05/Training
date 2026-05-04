class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  extend FriendlyId
  friendly_id :title, use: :slugged

  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :content, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["likes", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "content", "created_at", "updated_at", "user_id"]
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end
end
