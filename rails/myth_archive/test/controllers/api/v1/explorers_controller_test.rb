require "test_helper"

class Api::V1::ExplorersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @explorer = explorers(:one)
  end

  test "should get index" do
    get api_v1_explorers_url

    assert_response :success
  end

  test "should get show" do
    get api_v1_explorer_url(@explorer)

    assert_response :success
  end
end
