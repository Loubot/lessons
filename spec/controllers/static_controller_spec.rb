require 'rails_helper'
require 'spec_helper'
include Devise::TestHelpers

describe StaticController do 

  it "should get welcome" do
    # Note, rails 3.x scaffolding may add lines like get :index, {}, valid_session
    # the valid_session overrides the devise login. Remove the valid_session from your specs
    get 'welcome'
    expect(response).to be_success
  end

  it "should get teach" do
  	get 'teach'
  	expect(response).to be_success
  end

  it "should get learn" do
  	get 'learn'
  	expect(response).to be_success
  end

  it "should get mailing list" do
  	get "mailing_list"
  	expect(response).to be_success
  end

  it "should get how_it_works" do
  	get :how_it_works
  	expect(response).to be_success
  end

  login_teacher


  it "should have a current_teacher" do
    # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_teacher).not_to be_nil
  end
end
