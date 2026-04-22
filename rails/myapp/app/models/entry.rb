class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[Message Comment]

  # Delegation
  delegate :title, to: :entryable, allow_nil: true
end