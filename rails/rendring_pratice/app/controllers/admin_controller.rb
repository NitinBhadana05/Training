class AdminController < ApplicationController
  #layout "admin"
  before_action :require_login
  before_action :check_admin

  def dashboard
    @posts = Post.all
  end
end