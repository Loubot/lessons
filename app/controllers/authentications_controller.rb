class AuthenticationsController < Devise::OmniauthCallbacksController

  before_action :authenticate_teacher!, only:[:destroy]
  
  def oauth
    puts "provider #{request.env["omniauth.auth"]['provider']}"
    puts "referrer #{request.env['omniauth.origin']}"
    if teacher_signed_in?
      @identity = current_teacher.identities.find_or_create_identity(request.env["omniauth.auth"]) 
      

      if @identity.persisted?
        
        flash[:success] = "#{ current_teacher.email } signed in successfully"
        sign_in_and_redirect @identity.teacher
      else
        @identity.save!
        flash[:success] = "#{ current_teacher.email } signed in successfully. "
        flash[:success] << "#{get_provider_name(request.env["omniauth.auth"]['provider'])} added to login methods."
        sign_in_and_redirect current_teacher
      end
    else 
      @identity = Identity.find_or_create_identity(request.env["omniauth.auth"])
      if @identity.persisted?
        flash[:success] = "#{ @identity.teacher.email } signed in successfully."
        sign_in_and_redirect @identity.teacher
      else
        @teacher = Teacher.from_omniauth(request.env["omniauth.auth"])
        if @teacher.persisted?
          @identity.update_attributes(teacher_id: @teacher.id)
          @identity.save!
          flash[:success] = "#{ @teacher.email } signed in successfully. "
          flash[:success] << "#{get_provider_name(request.env["omniauth.auth"]['provider'])} added to login methods."
          sign_in_and_redirect @teacher
        elsif !@teacher.persisted? && request.env["omniauth.auth"]['provider'] == 'twitter'
          flash[:danger] = "You can't register using twitter. Please register using an email and you can add twitter as an authenitcation method after!"
          redirect_to root_url
        else
          session["devise.facebook_data"] = request.env['omniauth.auth']
          puts "Session  #{session["devise.facebook_data"]}"
          redirect_to new_registration_path
        end
      end
    end
    
  end

  alias_method :facebook, :oauth
  alias_method :google_oauth2, :oauth
  alias_method :twitter, :oauth

  def destroy
    puts "hello"
    redirect_to :back
  end


  private
    def get_provider_name(request)
      case request
      when 'facebook'
        'Facebook'
      when 'twitter'
        'Twitter'
      else
        'Google'
      end
    end

end

