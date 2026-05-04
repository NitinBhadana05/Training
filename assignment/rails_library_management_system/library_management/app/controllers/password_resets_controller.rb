class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  before_action :set_user_from_token, only: [:edit, :update]

  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase.strip)
    UserMailer.password_reset(user).deliver_now if user&.generate_password_reset_token!

    redirect_to login_path, notice: "If that email exists, password reset instructions will be sent."
  end

  def edit
  end

  def update
    if password_params[:password].blank?
      @user.errors.add(:password, "can't be blank")
      render :edit, status: :unprocessable_entity
    elsif @user.update(password_params)
      @user.clear_password_reset!
      redirect_to login_path, notice: "Password updated. You can login now."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user_from_token
    @user = User.find_by(email: params[:email].to_s.downcase.strip)
    return if @user&.password_reset_token_valid?(params[:token])

    redirect_to new_password_reset_path, alert: "Password reset link is invalid or expired."
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
