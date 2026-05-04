require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    @post = posts(:one)
    @other_post = posts(:two)
  end

  test "guest can like a public post" do
    assert_difference("Like.count", 1) do
      post post_like_url(@post)
    end

    assert_redirected_to post_url(@post)
    assert_not_nil session[:guest_token]
  end

  test "creates one like for the signed in user's own post" do
    sign_in @user

    assert_no_difference("Like.count") do
      post post_like_url(@post)
    end

    assert_redirected_to post_url(@post)
  end

  test "allows liking another user's public post" do
    sign_in @user

    assert_difference("Like.count", 1) do
      post post_like_url(@other_post)
    end

    assert_redirected_to post_url(@other_post)
  end

  test "destroys a signed in user's existing like" do
    sign_in @other_user

    assert_difference("Like.count", -1) do
      delete post_like_url(@other_post)
    end

    assert_redirected_to post_url(@other_post)
  end

  test "guest can unlike with the same session" do
    post post_like_url(@post)

    assert_difference("Like.count", -1) do
      delete post_like_url(@post)
    end

    assert_redirected_to post_url(@post)
  end
end
