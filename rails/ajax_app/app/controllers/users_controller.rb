class UsersController < ApplicationController
  def index
    if params[:query].present?
      @users = User.where("name LIKE :q OR email LIKE :q", q: "%#{params[:query]}%")
    else
      @users = User.all
    end

    respond_to do |format|
      format.html
      format.json { render partial: @users}
    end

     
  end

  def new
    @user = User.new
  end

  def create
    
    @user = User.new(user_params) 

    
    if @user.save 
      redirect_to @user, notice: "User created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def check_email
    exists = User.exists?(email: params[:email])

    render json: { exists: exists }
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    render json: { success: true }
  end

  private
  def user_params
    params.require(:user).permit(:name, :age, :email) 
  end
end
