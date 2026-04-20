class Admin < ApplicationRecord
  validates :admin_code, presence: true, unless: :is_admin
end
