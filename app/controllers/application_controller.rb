class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  include ApplicationHelper

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :first_name, :last_name, :is_teacher) }
  end

 #  def after_sign_in_path_for(resource)
 #    case resource.is_teacher
 #    when false
 #      # root_path
 #    else
 #      # edit_teacher_path(resource)
 #      redirect_to 'back' and return
 #    end    
	# end

  def after_sign_in_path_for(resource)
    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')

    if URI(request.referer).path == teach_path || URI(request.referer).path == learn_path
      root_path 
    else
      stored_location_for(resource) || request.referer || root_path
    end    
  end
    
  def after_sign_up_path_for(resource)
    case resource.is_teacher
    when false
      root_path
    else
      edit_teacher_path(resource)
    end  
  end
	
end

