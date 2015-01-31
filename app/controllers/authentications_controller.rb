class AuthenticationsController < Devise::OmniauthCallbacksController
  
  def facebook
    @teacher = Teacher.from_omniauth(request.env["omniauth.auth"])

    if @teacher.persisted?
      redirect_to root_url
      flash[:success] = "Signed in successfully"
    else
      if @teacher.save
        flash[:success] = "successfully registered"
        redirect_to root_url
      else
        flash[:danger] = "#{@teacher.errors.full_messages}"
        redirect_to root_url
      end
    end
  end
end

