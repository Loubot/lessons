class AuthenticationsController < Devise::OmniauthCallbacksController
  
  def oauth
    puts "referrer #{request.env['omniauth.origin']}"
    if teacher_signed_in?
      @identity = current_teacher.identities.find_or_create_identity(request.env["omniauth.auth"]) 
      p "1"

      if @identity.persisted?
        p "2"
        flash[:success] = "Signed in successfully"
        sign_in_and_redirect @identity.teacher
      else
        @identity.save!
        p "3"
        flash[:success] = "#{get_provider_name(request.env["omniauth.auth"]['provider'])} added to login methods."
        sign_in_and_redirect current_teacher
      end
    else 
      @identity = Identity.find_or_create_identity(request.env["omniauth.auth"])
      if @identity.persisted?
        flash[:success] = "Signed in successfully."
        sign_in_and_redirect @identity.teacher
      else
        @teacher = Teacher.from_omniauth(request.env["omniauth.auth"])
        if @teacher.persisted?
          @identity.update_attributes(teacher_id: @teacher.id)
          @identity.save!
          flash[:success] = "Signed in successfully. "
          flash[:success] << "#{get_provider_name(request.env["omniauth.auth"]['provider'])} added to login methods."
          sign_in_and_redirect @teacher
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


  private
    def get_provider_name(request)
      case request
      when 'facebook'
        'Facebook'
      else
        'Google'
      end
    end

end

