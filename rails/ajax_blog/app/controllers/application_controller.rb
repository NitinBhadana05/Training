class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :admin_signed_in?
  helper_method :current_guest_token

  private

  def admin_signed_in?
    admin_user_signed_in?
  end

  def current_guest_token
    session[:guest_token] ||= SecureRandom.hex(16)
  end
end
