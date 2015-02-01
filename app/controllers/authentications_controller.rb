class AuthenticationsController < Devise::OmniauthCallbacksController
  
  def facebook
    if teacher_signed_in?
      @identity = current_teacher.identities.find_or_create_identity(request.env["omniauth.auth"]) 
      

      if @identity.persisted?
        flash[:success] = "Signed in successfully"
        sign_in_and_redirect @identity.teacher
      else
        @identity.save!
       
        flash[:success] = "#{request.env["omniauth.auth"]['provider'].capitalize} added to login methods."
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
          flash[:success] << "#{request.env["omniauth.auth"]['provider'].capitalize} added to login methods."
          sign_in_and_redirect @teacher
        else
          session["devise.facebook_data"] = request.env['omniauth.auth']
          puts "Session  #{session["devise.facebook_data"]}"
          redirect_to new_registration_path
        end
      end
    end
    # @teacher = Teacher.find_by_email(request.env["omniauth.auth"]['info']['email'] )
    # # @teacher = Teacher.from_omniauth(request.env["omniauth.auth"])

    # if @teacher.persisted?
    #   sign_in_and_redirect @teacher
    #   flash[:success] = "Signed in successfully"
    # else
      
    #   session["devise.facebook_data"] = request.env['omniauth.auth']
    #   puts "Session  #{session["devise.facebook_data"]}"
    #   redirect_to new_registration_path
    # end
  end
end

