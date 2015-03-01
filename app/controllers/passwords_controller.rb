class PasswordsController < Devise::PasswordsController

  before_action :get_categories

  def get_categories
    @categories = Category.includes(:subjects).all
  end

  protected

    def after_sending_reset_password_instructions_path_for(resource_name)
      '/'
    end
end