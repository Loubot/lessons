class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    puts "auth  #{auth['extra']['raw_info']['email']}"
    if !(@identity = Identity.find_by_omniauth(auth))
      puts "aaaaaaaaaaaa"
      if !teacher_signed_in? 
        puts "bbbbbbbbbbbbbbbbbbbbb"
        flash[:danger] = "You must be logged in to add a new login scheme"
      else
        puts "herre ££££££££££"
        current_teacher.add_identity(auth)
      end
    end
    # if teacher.persisted?
    #   sign_in teacher
    #   flash[:success] = "Signed in successfully."
    #   redirect_to '/'
    # else
    #   teacher.finish_reg(auth['extra']['raw_info'].slice(:email, :first_name, :last_name))
    #   if teacher.save
    #     puts 'yep'
    #     flash[:success] = 'yep'
    #     redirect_to '/'
    #   else

    #     flash[:danger] = teacher.errors.full_messages
    #     redirect_to '/'
    #   end
    # end
    redirect_to '/'
    
  end

  alias_method :facebook, :all

end