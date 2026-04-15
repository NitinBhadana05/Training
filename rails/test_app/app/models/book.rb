class Book < ApplicationRecord

  # category and publisher relations
  belongs_to :category
  belongs_to :publisher

  # copies and borrow records
  has_many :copies
  has_many :borrows, through: :copies

  # author relations (many-to-many)
  has_many :book_authors
  has_many :authors, through: :book_authors

  # title is required
  validates :title, presence: true

  # isbn must be unique and 13 characters
  validates :isbn, uniqueness: true, length: { is: 13 }

  # pages must be greater than 0
  validates :pages, numericality: { greater_than: 0 }

end