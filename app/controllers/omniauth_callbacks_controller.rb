class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    uri = redirect_path(request)
    # uri = URI.parse(URI.encode(request.env['omniauth.origin'])).path
    # puts "origin!! #{URI(request.env['omniauth.origin']).path}"
    # puts "auth  #{auth['extra']['raw_info']['email']}"
    puts "uri: #{uri}"
    identity = Identity.find_or_initialize_by(uid: auth[:uid], provider: auth[:provider])
    
    if teacher_signed_in?  #teacher signed in
      
      if identity.new_record?  #identity is new and teacher is signed in
        current_teacher.add_identity(auth)
        puts "££££££££££££££££££1"
        flash[:success] = "Login method added"
        redirect_to uri
      else # identitiy is not new and teacher is signed in
        puts "££££££££££££££££££2"
        flash[:success] = "Login method already exists"
        redirect_to uri      
      end      
    else  #teacher not signed in
      if !(identity.new_record?) #identitiy is not new and teacher is not signed in
        puts "££££££££££££££££££3"
        redirect_to '/', notice: "no teacher id" and return if !(identity.teacher_id) 
        flash[:success] = "Signed in succesfully"

        sign_in identity.teacher
        redirect_to uri
      else # identity is new and teacher is not signed in
        if (teacher = Teacher.find_by(email: auth['extra']['raw_info']['email'])) #can find a teacher
          teacher.add_identity(auth)
          puts "££££££££££££££££££4"
          flash[:success] = "Signed in with #{auth[:provider]}"
          sign_in teacher
          redirect_to uri
        else #could not find teacher and identity is new
          teacher = Teacher.create_new_with_omniauth(auth, URI(request.env['omniauth.origin']).path)
          puts "££££££££££££££££££5"
          redirect_to '/' and return if !teacher.valid?
          flash[:success] = "Registered succesfully using #{auth[:provider]}"
          sign_in teacher
          redirect_to uri
        end
      end
    end
  end

  alias_method :facebook, :all

  def redirect_path(request)
    # puts "bla #{URI.parse(URI.encode(request.env['omniauth.origin'])).path}"
    if URI.parse(URI.encode(request.env['omniauth.origin'])).path == '/display-subjects'
      uri = URI.encode(request.env['omniauth.params'].map { |k,v| v.to_s }.join('&'))
      params = request.env['omniauth.params']
      p params
      p params['search_subjects']
      display_subjects_path(:search_subjects => params['search_subjects'],:search_position => params['search_position'])
    else
      request.env['omniauth.origin']
    end
  end

end