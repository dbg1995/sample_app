require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end
  test "user not exist" do
    get "/users/aaaa"
    follow_redirect!
    assert_template root_path
    assert_not flash.empty?
  end
end
