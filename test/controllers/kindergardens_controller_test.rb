require 'test_helper'

class KindergardensControllerTest < ActionController::TestCase
  test "should get search" do
    get :search
    assert_response :success
  end

  test "should get searchResult" do
    get :searchResult
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get inEdit" do
    get :inEdit
    assert_response :success
  end

  test "should get inUpdate" do
    get :inUpdate
    assert_response :success
  end

end
