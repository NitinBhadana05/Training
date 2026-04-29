require "test_helper"

class IssuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    post login_path, params: { email: users(:one).email, password: "password" }
  end

  test "should get new" do
    get new_issue_url
    assert_response :success
  end

  test "should create issue" do
    assert_difference("Issue.count", 1) do
      post issues_url, params: {
        issue: {
          user_id: users(:one).id,
          book_id: books(:two).id,
          issue_date: Date.current
        }
      }
    end

    assert_redirected_to books_url
    assert_not books(:two).reload.available
  end

  test "should return book" do
    issue = Issue.create!(user: users(:one), book: books(:two), issue_date: Date.current)

    patch return_book_issue_url(issue)

    assert_redirected_to books_url
    assert issue.reload.return_date.present?
    assert books(:two).reload.available
  end
end
