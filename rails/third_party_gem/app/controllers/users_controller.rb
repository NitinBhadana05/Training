class UsersController < ApplicationController

  def index
    @user = User.all
  end
  def show
    
    @user = User.friendly.find(params[:id])
  end
end
