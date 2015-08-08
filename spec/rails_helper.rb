# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'support/controller_macros'
require 'support/teacher_types'

# require 'support/omniauth'

require 'capybara/rails'
require 'capybara/rspec'

require 'rack/utils'
Capybara.app = Rack::ShowExceptions.new(Lessons::Application)

OmniAuth.config.test_mode = true

Capybara.default_host = 'http://localhost:3000'

Capybara.ignore_hidden_elements = false

Capybara.javascript_driver = :webkit

OmniAuth.config.add_mock(:facebook, {
  :uid => '12345',
  :nickname => 'zapnap'
})

OmniAuth.config.add_mock(:twitter, {
  :uid => '111',
  :nickname => 'zapnap'
})

OmniAuth.config.add_mock(:google_oauth2, {
  :uid => '222',
  :nickname => 'zapnap'
})

OmniAuth.config.add_mock(:linkedin, {
  :uid => '12333345',
  :nickname => 'zapnap'
})


Capybara::Webkit.configure do |config|
  config.allow_unknown_urls
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Capybara::DSL

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include Devise::TestHelpers, :type => :controller
  config.include TeacherTypes
  config.extend ControllerMacros, :type => :controller
  # Capybara.javascript_driver = :webkit
  # Capybara.app_host = 'http://localhost:3000'


  config.include Warden::Test::Helpers
  config.before :suite do
    Warden.test_mode!
  end

  config.after :each do
    Warden.test_reset!
  end
  
    
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end

def drop_files files, drop_area_id
  js_script = "fileList = Array();"
  files.count.times do |i|
    # Generate a fake input selector
    page.execute_script("if ($('#seleniumUpload#{i}').length == 0) { seleniumUpload#{i} = window.$('<input/>').attr({id: 'seleniumUpload#{i}', type:'file'}).appendTo('body'); }")
    # Attach file to the fake input selector through Capybara
    attach_file("seleniumUpload#{i}", files[i])
    # Build up the fake js event
    js_script = "#{js_script} fileList.push(seleniumUpload#{i}.get(0).files[0]);"
  end

  # Trigger the fake drop event
  page.execute_script("#{js_script} e = $.Event('drop'); e.originalEvent = {dataTransfer : { files : fileList } }; $('##{drop_area_id}').trigger(e);")
end
