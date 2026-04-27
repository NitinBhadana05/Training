class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :admin_user?

  private
    def current_user
      Current.user
    end

    def admin_user?
      current_user&.admin?
    end

    def require_admin!
      return if admin_user?

      redirect_to root_path, alert: "You are not authorized to access that page."
    end
end
