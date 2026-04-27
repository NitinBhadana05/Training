require "test_helper"

class IssuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @issue = issues(:one)
  end

  test "shows user issue list when signed in" do
    sign_in_as(users(:one))

    get issues_url
    assert_response :success

    get issue_url(@issue)
    assert_response :success
  end

  test "blocks normal users from admin issue page" do
    sign_in_as(users(:one))

    get new_issue_url
    assert_redirected_to root_path
  end

  test "allows admins to access new issue page" do
    sign_in_as(users(:admin))

    get new_issue_url
    assert_response :success
  end

  test "allows admin to update due date" do
    sign_in_as(users(:admin))

    patch issue_url(@issue), params: { issue: { due_date: Date.new(2026, 5, 1) } }

    assert_redirected_to issue_path(@issue)
    assert_equal Date.new(2026, 5, 1), @issue.reload.due_date
  end
end
