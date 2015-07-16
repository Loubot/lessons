require 'test_helper'

class StaticControllerTest < ActionController::TestCase

  fixtures :teachers

  test "should display how it works" do 

    get :how_it_works
    assert_response :success
  end

  test "should display mailing-list" do 

    get :mailing_list
    assert_response :success

  end

  test "should display welcome" do

    get :welcome
    assert_response :success

  end

  

  test "should display learn" do

    get :learn
    assert_response :success
  end

  test "should display teach" do

    get :teach
    assert_response :success
  end

  test "should display browse-categories" do

    get :browse_categories
    assert_response :success
  end

  

  teacher = teachers(:louis)
end
