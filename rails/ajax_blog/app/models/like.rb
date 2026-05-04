class Like < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :post

  validates :guest_token, uniqueness: { scope: :post_id }, allow_nil: true
  validates :user_id, uniqueness: { scope: :post_id }, allow_nil: true
  validate :user_or_guest_present

  def self.ransackable_attributes(auth_object = nil)
    ["guest_token", "id", "user_id", "post_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "post"]
  end

  private

  def user_or_guest_present
    return if user_id.present? || guest_token.present?

    errors.add(:base, "Like must belong to a signed-in user or guest session")
  end
end
