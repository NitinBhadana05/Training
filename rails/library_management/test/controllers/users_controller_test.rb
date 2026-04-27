require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "allows public signup for normal users" do
    assert_difference("User.count", 1) do
      post users_url, params: {
        user: {
          full_name: "Public Member",
          email_address: "member@example.com",
          password: "Password@123",
          password_confirmation: "Password@123",
          role: "admin"
        }
      }
    end

    created_user = User.find_by!(email_address: "member@example.com")
    assert_redirected_to root_path
    assert_equal "user", created_user.role
  end

  test "allows admin to edit a user" do
    sign_in_as(users(:admin))

    patch user_url(users(:one)), params: {
      user: { full_name: "Updated User", email_address: users(:one).email_address, role: "user" }
    }

    assert_redirected_to user_path(users(:one))
    assert_equal "Updated User", users(:one).reload.full_name
  end

  test "allows admin to view user index" do
    sign_in_as(users(:admin))

    get users_url
    assert_response :success
  end

  test "blocks normal user from admin pages" do
    sign_in_as(users(:one))

    get users_url
    assert_redirected_to root_path
  end

  test "blocks normal user from edit page" do
    sign_in_as(users(:one))

    get edit_user_url(users(:one))
    assert_redirected_to root_path
  end

  test "allows user to view their profile" do
    sign_in_as(users(:one))

    get user_url(users(:one))
    assert_response :success
  end
end
