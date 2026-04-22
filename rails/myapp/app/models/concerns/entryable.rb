module Entryable
  extend ActiveSupport::Concern

  included do
    has_one :entry, as: :entryable, dependent: :destroy
  end
end