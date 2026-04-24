class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user

  private

  def current_user
    @current_user ||= NewUser.find_by(id: session[:user_id])
  end

  def require_login
    unless current_user
      render plain: "Please login"
    end
  end

  def check_admin
    unless current_user && current_user.role.name == "admin"
      render plain: "Access Denied"
    end
  end
  
end
