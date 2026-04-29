require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post users_url, params: {
        user: {
          name: "Charlie Reader",
          email: "charlie@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to books_url
  end

  test "should get index" do
    post login_path, params: { email: users(:one).email, password: "password" }
    get users_url
    assert_response :success
  end
end
