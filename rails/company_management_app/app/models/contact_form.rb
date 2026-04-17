class ContactForm
  include ActiveModel::Model
  attr_accessor :name, :email, :message

  validates :name, :email, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def submit
    return false unless valid?
    # Mailer.contact(name, email, message).deliver_now
    true
  end
end