class AuthenticationsController < Devise::OmniauthCallbacksController
  
  def facebook
    @teacher = Teacher.from_omniauth(request.env["omniauth.auth"])

    if @teacher.persisted?
      redirect_to root_url
      flash[:success] = "Signed in successfully"
    else
      
      session["devise.facebook_data"] = request.env['omniauth.auth']
      puts "Session  #{session["devise.facebook_data"]}"
      redirect_to new_registration_path
    end
  end
end

