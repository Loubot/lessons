class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    puts "auth  #{auth['extra']['raw_info']['email']}"
    teacher = Teacher.find_or_initialize_by(email: auth['extra']['raw_info']['email'])
    if teacher.persisted?
      sign_in teacher
      flash[:success] = "Signed in successfully."
      redirect_to '/'
    else
      teacher.finish_reg(auth['extra']['raw_info'].slice(:email, :first_name, :last_name))
      if teacher.save
        puts 'yep'
        flash[:success] = 'yep'
        redirect_to '/'
      else

        flash[:danger] = teacher.errors.full_messages
        redirect_to '/'
      end
    end
    
    
  end

  alias_method :facebook, :all

end