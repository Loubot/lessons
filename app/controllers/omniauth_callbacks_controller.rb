class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    puts "auth  #{auth.to_yaml}"
    # flash[:success] = auth.slice(:email)
    redirect_to '/'
  end

  alias_method :facebook, :all

end