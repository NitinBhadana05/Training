class Event < ApplicationRecord
  validates :end_date, comparison: { greater_than: :start_date }
  validates :end_date, presence: true, if: -> { start_date.present? }

end
