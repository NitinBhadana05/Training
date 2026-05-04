require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    @post = posts(:one)
    @other_post = posts(:two)
  end

  test "allows guests to browse posts" do
    get posts_url
    assert_response :success
    assert_select "h2", text: @post.title
    assert_select "h2", text: @other_post.title
  end

  test "allows guests to view a post" do
    get post_url(@other_post)

    assert_response :success
    assert_match @other_post.title, @response.body
  end

  test "creates post for signed in user" do
    sign_in @user

    assert_difference("Post.count", 1) do
      post posts_url, params: { post: { title: "Private draft", content: "Owned by the signed in user." } }
    end

    assert_redirected_to post_url(Post.last)
    assert_equal @user, Post.last.user
  end

  test "redirects guests from new post form" do
    get new_post_url

    assert_redirected_to new_user_session_url
  end

  test "prevents guests from editing a post" do
    get edit_post_url(@post)

    assert_redirected_to new_user_session_url
  end

  test "prevents editing another user's post" do
    sign_in @user

    patch post_url(@other_post), params: { post: { title: "Hacked" } }

    assert_response :not_found
    assert_not_equal "Hacked", @other_post.reload.title
  end

  test "deletes only the signed in user's post" do
    sign_in @user

    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end
end
