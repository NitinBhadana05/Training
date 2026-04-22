class Fine < ApplicationRecord
  belongs_to :rental, dependent: :destroy

  validates :amount,presence: true, numericality: { greater_than: 0 }
end
