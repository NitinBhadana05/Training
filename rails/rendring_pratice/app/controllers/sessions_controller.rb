class SessionsController < ApplicationController

  def new
    
  end

  def create
    user = NewUser.find_by(email: params[:email], password: params[:password])

    if user
      session[:user_id] = user.id
      
      render "pages/home"

    else
      render plain: "Invalid credentials"
    end
  end

  def destroy
    session[:user_id] = nil
    render plain: "Logged out"
  end

end
