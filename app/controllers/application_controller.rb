class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  include ApplicationHelper

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :first_name, :last_name) }
  end

  def after_sign_in_path_for(resource)
    case resource
    when :user, User
      root_path
    else
      edit_teacher_path(resource)
    end    
	end

  def after_sign_up_path_for(resource)
    case resource
    when :user, User
      root_path
    else
      edit_teacher_path(resource)
    end  
  end
	
end

