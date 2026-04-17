class UserForm
  include ActiveModel::Model
  attr_accessor :name, :email, :age

  validates :name, :email,  presence: true
  validate :email_format
  validates :age, numericality: { greater_than: 0 }


  
  def submit
  return false unless valid?

  puts "Form submitted for #{name}"
  true
  end
  def email_format
    unless email.include?("@")
      errors.add(:email, "invalid format")
    end
  end
end