class Book < ApplicationRecord
    has_many :issues, dependent: :destroy
    has_many :users, through: :issues

    validates :title, :author, :isbn, presence: true
    validates :isbn, uniqueness: true

    before_create :set_default_availability

    private

    def set_default_availability
        self.available = true if available.nil?
    end

end
