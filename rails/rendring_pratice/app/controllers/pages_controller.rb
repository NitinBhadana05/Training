class PagesController < ApplicationController
  #layout "mailer"
  def home
   

  end

  def contact
  end

  def user
     @users = User.all
  end
end
