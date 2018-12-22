require 'test_helper'

class NokogiriControllerTest < ActionController::TestCase
  test "should get region" do
    get :region
    assert_response :success
  end

end
