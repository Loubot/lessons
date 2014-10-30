class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    puts "origin!! #{request.env['omniauth.origin']}"
    puts "auth  #{auth['extra']['raw_info']['email']}"
    if !(@identity = Identity.find_by_omniauth(auth))
      puts "aaaaaaaaaaaa"
      if !teacher_signed_in?
        teacher = Teacher.find_or_initialize_by(email: auth['extra']['raw_info']['email'])

        teacher.create_new_with_omniauth(auth) if teacher.new_record?

        flash[:success] = "Signed in successfully"
        sign_in_and_redirect teacher
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