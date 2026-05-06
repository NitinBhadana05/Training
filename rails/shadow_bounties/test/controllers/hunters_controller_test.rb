require "test_helper"

class HuntersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get hunters_index_url
    assert_response :success
  end

  test "should get new" do
    get hunters_new_url
    assert_response :success
  end

  test "should get edit" do
    get hunters_edit_url
    assert_response :success
  end

  test "should get show" do
    get hunters_show_url
    assert_response :success
  end
end
