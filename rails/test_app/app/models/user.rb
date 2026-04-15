class User < ApplicationRecord

   # user has many borrow records
  has_many :borrows

  # user can access copies through borrows
  has_many :copies, through: :borrows

  # name must be present
  validates :name, presence: true

  # email must be present and unique
  validates :email, presence: true, uniqueness: true

  # role can only be admin or member
  validates :role, inclusion: { in: %w[admin member] }
end
 