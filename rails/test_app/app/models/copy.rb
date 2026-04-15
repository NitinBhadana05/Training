class Copy < ApplicationRecord

# link to book
  belongs_to :book

  # related borrow entries
  has_many :borrows

  # ensure unique barcode
  validates :barcode, uniqueness: true

  # allow only valid status values
  validates :status, inclusion: { in: %w[available issued damaged] }
  
end
