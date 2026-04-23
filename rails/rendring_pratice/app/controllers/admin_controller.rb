class AdminController < ApplicationController
  layout "admin"

  def dashboard
    @posts = Post.all
  end
end