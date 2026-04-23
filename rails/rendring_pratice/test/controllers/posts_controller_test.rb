require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get posts_index_url
    assert_response :success
  end

  test "should get show" do
    get posts_show_url
    assert_response :success
  end

  test "should get create" do
    get posts_create_url
    assert_response :success
  end

  test "should get go_home" do
    get posts_go_home_url
    assert_response :success
  end

  test "should get check" do
    get posts_check_url
    assert_response :success
  end
end
