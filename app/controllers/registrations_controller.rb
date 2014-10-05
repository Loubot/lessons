class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&"
    if resource == :user
      puts "VVVVVVVVVVVVVVVVVVVVVVVVVVVV"
      root_path
    else
      puts "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
      edit_teacher_path(resource)
    end
  end

  
end