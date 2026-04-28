class Task < ApplicationRecord
  before_create :set_default_status

  validates :title, presence: true

  private

  def set_default_status
    self.status = "pending"
  end
end