class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    puts "origin!! #{request.env['omniauth.origin']}"
    puts "auth  #{auth['extra']}"
    if !(@identity = Identity.find_by_omniauth(auth))
      puts "aaaaaaaaaaaa"
      if !teacher_signed_in? 
        puts "bbbbbbbbbbbbbbbbbbbbb"
        flash[:danger] = "You must be logged in to add a new login scheme"
      else
        puts "herre ££££££££££"
        current_teacher.add_identity(auth)
      end
    else
      flash[:success] = "Signed in successfully"
      sign_in_and_redirect @identity.teacher
      
    end   
  end

  alias_method :facebook, :all

end