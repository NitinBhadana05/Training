class UserMailer < ApplicationMailer
  default from: "library@example.com"

  def password_reset(user)
    @user = user
    @reset_url = edit_password_reset_url(token: @user.reset_password_token, email: @user.email)

    mail(to: @user.email, subject: "Reset your Library Stack password")
  end
end
