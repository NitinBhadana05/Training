class Comment < ApplicationRecord
  belongs_to :post
#polymorphic association
  belongs_to :commentabe, polymorphic: true

   include Entryable

  def title
    "Comment: #{text}"
  end
end
