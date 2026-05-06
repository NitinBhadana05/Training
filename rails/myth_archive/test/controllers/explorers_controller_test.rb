require "test_helper"

class ExplorersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @explorer = explorers(:one)
  end

  test "should get index" do
    get explorers_url
    assert_response :success
  end

  test "should get show" do
    get explorer_url(@explorer)
    assert_response :success
  end

  test "should get new" do
    get new_explorer_url
    assert_response :success
  end

  test "should get edit" do
    get edit_explorer_url(@explorer)
    assert_response :success
  end
end
