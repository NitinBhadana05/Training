class Message < ApplicationRecord
  include Entryable

  def title
    "Message: #{content}"
  end
end