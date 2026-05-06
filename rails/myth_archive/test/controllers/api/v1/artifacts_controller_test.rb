require "test_helper"

class Api::V1::ArtifactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artifact = artifacts(:one)
  end

  test "should get index" do
    get api_v1_artifacts_url

    assert_response :success
  end

  test "should get show" do
    get api_v1_artifact_url(@artifact)

    assert_response :success
  end
end
