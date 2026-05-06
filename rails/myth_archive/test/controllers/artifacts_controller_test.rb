require "test_helper"

class ArtifactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artifact = artifacts(:one)
    @explorer = @artifact.explorer
  end

  test "should get index" do
    get explorer_artifacts_url(@explorer)
    assert_response :success
  end

  test "should get show" do
    get explorer_artifact_url(@explorer, @artifact)
    assert_response :success
  end

  test "should get new" do
    get new_explorer_artifact_url(@explorer)
    assert_response :success
  end

  test "should get edit" do
    get edit_explorer_artifact_url(@explorer, @artifact)
    assert_response :success
  end
end
