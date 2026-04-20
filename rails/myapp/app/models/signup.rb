class Signup < ApplicationRecord
  validates :terms_and_conditions, acceptance: true
end
