module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:teacher]
      sign_in FactoryGirl.create(:teacher, :admin) # Using factory girl as an example
    end
  end

  def login_teacher
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:teacher]
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean
      teacher = FactoryGirl.create(:teacher)
      # teacher.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in teacher
    end
  end
end