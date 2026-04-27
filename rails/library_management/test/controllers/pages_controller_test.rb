require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated users from home" do
    get root_url
    assert_redirected_to new_session_path
  end

  test "shows protected pages for signed in users" do
    sign_in_as(users(:one))

    get root_url
    assert_response :success

    get about_url
    assert_response :success
  end
end
