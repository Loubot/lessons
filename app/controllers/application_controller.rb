class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_mobile?
  include ApplicationHelper

  def is_mobile?
    session[:mobile]    
  end

  helper_method :is_mobile?

  def update_student_address(params) #update teacher address if 
    if params[:save_address] == 'true'
      if current_teacher.address != params[:home_address]
        
        current_teacher.update_attributes(address: params[:home_address]) 
      end
    else #set student address to '' if save address checkbox isn't ticked
      
      current_teacher.update_attributes(address: '') if current_teacher.address != ''
    end
  end

  def valid_email?(email)
    valid_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    email =~ valid_regex
  end   
  
  private


      def check_mobile?

        session[:mobile] = browser.mobile? # gem browser
      end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :first_name, :last_name, :is_teacher, :password_confirmation, :invitation_token) }
  end


  def after_sign_in_path_for(resource)
    logger.info "request.referer #{request.referer}"
    # puts "request #{request.env['omniauth.origin']}"
    # flash[:danger] = resource.is_teacher_valid_message if resource.is_teacher_valid_message && resource.is_teacher
    
    if request.env['omniauth.origin']
      if URI.parse(URI.encode(request.env['omniauth.origin'])).path == '/display-subjects' #create display_subjects url with params

        params = request.env['omniauth.params']        
        display_subjects_path(:search_subjects => params['search_subjects'],:search_position => params['search_position'])
      elsif URI.parse(URI.encode(request.env['omniauth.origin'])).path == '/show-teacher'
        params = request.env['omniauth.params']
        puts "params #{params}"
        puts "id #{params['origin']['id']}"
        show_teacher_path(subject_id: params['subject_id'], id: params['id'])
      elsif URI(request.env['omniauth.origin']).path == "/teach" || URI(request.env['omniauth.origin']).path == "/learn"
        '/'
      else
        puts "ApplicationController omniOrigin: #{request.env['omniauth.origin']}"
        request.env['omniauth.origin']
      end
    elsif URI(request.referer).path ==  "/teachers/password/edit" ||  URI(request.referer).path == '/teachers/sign_in'
      '/'
    elsif URI(request.referer).path == teach_path || URI(request.referer).path == learn_path
      root_path 
    else
      stored_location_for(resource) || request.referer || root_path
    end    
  end
    
  def after_sign_up_path_for(resource)
    case resource.is_teacher == true
    when false
      root_path
    else
      edit_teacher_path(resource)
    end  
  end
	
end

