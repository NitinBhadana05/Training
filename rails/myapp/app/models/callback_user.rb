class CallbackUser < ApplicationRecord
  # callback Registration
  before_save :normalize_email
  after_create :print_created

  def normalize_email
    self.email = email.downcase if email.present?
  end

  def print_created
    puts "User created"
  end

  #Create/ Update/ Destroy
  before_create :set_default_name
  before_update :log_update
  before_destroy :prevent_admin_delete

  def set_default_name
    self.name = "Anonymous" if name.blank?
  end

  def log_update
    puts "User updated"
  end

  def prevent_admin_delete
    if admin?
      errors.add(:base, "Cannot delete Admin")
      throw(:abort)
    end
  end
   

  #after_initialize and after_find
  after_initialize :after_init
  after_find :after_find_method

  def after_init
    puts "User initialized"
  end

  def after_find_method
    puts "User found"
  end



  #after_touch
  after_touch :after_touch_method

  def after_touch_method
    puts "User touched"
  end

  #Execution Order
  before_save :before_save_log
  before_create :before_create_log
  after_create :after_create_log
  after_save :after_save_log

  def before_save_log
    puts "before_save"
  end

  def before_create_log
    puts "before_create"
  end

  def after_create_log
    puts "after_create"
  end


  def after_save_log
    puts "after_save"
  end


  #Conditional
  before_save :normalize_name, if: :name_present?

  def normalize_name
    self.name = name.capitalize
  end

  def name_present?
    name.present?
  end

  # Conditional Proc
  before_save :log_email, if: -> {email.present? && email.include?("@gmail.com" )}

  def log_email
    puts "Email logged"
  end



  #unless
  before_save :block_guest, unless: :admin?

  def block_guest
    puts "Guest blocked"
  end
 
  def admin?
    role == "admin"
  end



  #multiple conditions
  before_save :secure_user, if: :name_present?, unless: :admin?

  def secure_user
    puts "User secure"
  end

  #pratice
  before_save :trim_name
  after_create :welcome_message
  before_destroy :block_important_email

  def trim_name
    self.name = name.strip if name.present?
  end

  def welcome_message
    puts "Welcome #{name}"
  end

  def block_important_email
    if email.include?("important")
      error.add(:base, "Cannot delete user with important email")
      throw(:abort)
    end
  end

end
