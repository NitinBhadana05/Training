class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_admin!, except: %i[show new create]

  def index
    @query = params[:query]
    @users = User.search(@query)
  end

  def new
    if authenticated? && !admin_user?
      redirect_to root_path, alert: "You are already signed in."
      return
    end

    @user = User.new(role: :user)
  end

  def create
    @user = User.new(sign_up_params)
    @user.role = resolved_role_for_create

    if @user.save
      if admin_user?
        redirect_to @user, notice: "User created successfully."
      else
        start_new_session_for(@user)
        redirect_to root_path, notice: "Your account has been created successfully."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    unless admin_user? || current_user == @user
      redirect_to root_path, alert: "You are not authorized to access that page."
      return
    end

    @issues = @user.issues.recent_first.limit(10)
    @bills = @user.bills.recent_first.limit(10)
  end

  def edit
  end

  def update
    if @user.update(admin_user_params)
      redirect_to @user, notice: "User updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to users_path, alert: "You cannot delete the current signed-in admin."
      return
    end

    @user.destroy
    redirect_to users_path, notice: "User deleted successfully.", status: :see_other
  rescue ActiveRecord::DeleteRestrictionError, ActiveRecord::InvalidForeignKey
    redirect_to @user, alert: "User cannot be deleted while associated records exist."
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def sign_up_params
      params.require(:user).permit(:full_name, :email_address, :password, :password_confirmation)
    end

    def admin_user_params
      params.require(:user).permit(:full_name, :email_address, :password, :password_confirmation, :role)
    end

    def resolved_role_for_create
      return params.dig(:user, :role).presence || "user" if admin_user?

      "user"
    end
end
