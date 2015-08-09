class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]


  def create
    # p "invitation #{params[:teacher][:invitation_token]}"
    build_resource(sign_up_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      
      Invitation.find_by_token(params[:teacher][:invitation_token]).update_attributes(accepted_at: Time.now, accepted: true) if params[:teacher].has_key?(:invitation_token)
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?

        send_welcome_mails(resource) #see below
        resource.delay.add_to_mailing_lists #steachers model

        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
        

      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
      AdminMailer.delay.user_registered(resource)
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      flash[:danger] = "Failed to register: #{resource.errors.full_messages.join(" and ")}"
      redirect_to :back
    end
  end

  
  private 

  def sign_up_params
    params.require(:teacher).permit(:email, :first_name, :last_name, :password, :password_confirmation, :is_teacher)
  end

  private
    def send_welcome_mails(teacher)

      if teacher.is_teacher == true
        TeacherMailer.delay.welcome_mail_teacher(teacher.first_name, teacher.email)
      else
        TeacherMailer.delay.welcome_mail_student(teacher.first_name, teacher.email)
      end
    end
  
end