class CustomFailure < Devise::FailureApp
  def redirect_url
    puts "soggy biscuits"
    :back
  end

  def respond
    store_location!
    flash[:alert] = i18n_message unless flash[:notice]
    if http_auth?
      puts "iuio"
      http_auth
    else
      puts "sdfsd"
      redirect_to root_url
    end
  end
end