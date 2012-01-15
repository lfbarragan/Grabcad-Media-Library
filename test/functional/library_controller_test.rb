require 'test_helper'

class LibraryControllerTest < ActionController::TestCase
  test "should get get_all" do
    get :get_all
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
