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
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    render json: { success: true }
  end
end
