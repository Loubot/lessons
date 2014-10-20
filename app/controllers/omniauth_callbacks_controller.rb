class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    raise request.env['omniauth.auth'].to_yaml
  end

end