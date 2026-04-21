class Post < ApplicationRecord
  has_many :comments
  validates :title, presence: true
  validates :content, presence: true, length: {minimum:5}
# polymorphic association
  has_many :comments, as: :commentable
  
end
