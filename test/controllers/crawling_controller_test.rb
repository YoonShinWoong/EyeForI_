require 'test_helper'

class CrawlingControllerTest < ActionController::TestCase
  test "should get crawling_view" do
    get :crawling_view
    assert_response :success
  end

end
