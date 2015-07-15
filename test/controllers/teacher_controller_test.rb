require 'test_helper'

class TeachersControllerTest < ActionController::TestCase

  

  test "should display edit" do 

    get :edit, id: 1
    assert_response 302

  end

end