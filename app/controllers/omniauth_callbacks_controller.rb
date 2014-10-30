class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    puts "origin!! #{URI(request.env['omniauth.origin']).path}"
    puts "auth  #{auth['extra']['raw_info']['email']}"
    
    identity = Identity.find_or_initialize_by(uid: auth[:uid], provider: auth[:provider])
    
    if teacher_signed_in?  #teacher signed in
      
      if identity.new_record?  #identity is new and teacher is signed in
        current_teacher.add_identity(auth)
        redirect_to request.env['omniauth.origin']
      else # identitiy is not new and teacher is signed in
        flash[:success] = "Signed in succesfully"
        sign_in_and_redirect identity.teacher
      end      
    else  #teacher not signed in
      if !(identity.new_record?) #identitiy is not new and teacher is not signed in
        flash[:success] = "Signed in succesfully"
        sign_in_and_redirect identity.teacher
      else # identity is new and teacher is not signed in
        if (teacher = Teacher.find_by(email: auth['extra']['raw_info']['email']))
          teacher.add_identity(auth)
          flash[:success] = "Signed in with #{auth[:provider]}"
          sign_in_and_redirect teacher
        else #could not find teacher and identity is new
          teacher = Teacher.create_new_with_omniauth(auth, URI(request.env['omniauth.origin']).path)
          flash[:success] = "Registered succesfully using #{auth[:provider]}"
          sign_in_and_redirect teacher
        end
      end
    end
  end

  alias_method :facebook, :all

end