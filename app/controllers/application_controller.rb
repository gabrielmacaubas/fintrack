class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Devise authentication
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  # CanCanCan authorization
  check_authorization unless: :devise_controller?

  # Handle authorization exceptions
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username])
  end
end

