class Comment < ApplicationRecord
  belongs_to :post
#polymorphic association
  belongs_to :commentabe, polymorphic: true
end
