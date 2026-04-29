require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_url
    assert_response :success
  end

  test "should create session" do
    post login_url, params: { email: users(:one).email, password: "password" }
    assert_redirected_to books_url
  end

  test "should destroy session" do
    post login_url, params: { email: users(:one).email, password: "password" }
    delete logout_url
    assert_redirected_to login_url
  end
end
