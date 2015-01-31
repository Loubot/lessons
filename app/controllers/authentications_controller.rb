class AuthenticationsController < Devise::OmniauthCallbacksController
  
  def facebook
    @teacher = Teacher.from_omniauth(request.env["omniauth.auth"])

    if @teacher.persisted?
      flash[:success] = "Signed in successfully"
      sign_in_and_redirect @teacher
      
      
    else      
      session["devise.facebook_data"] = request.env['omniauth.auth']
      puts "Session  #{session["devise.facebook_data"]}"
      redirect_to new_registration_path
    end
  end
end

