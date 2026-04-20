class Post1 < ApplicationRecord
  validates :title, length: { minimum: 5, maximum: 50 }
  validates :content, length: { minimum: 100 }
end
