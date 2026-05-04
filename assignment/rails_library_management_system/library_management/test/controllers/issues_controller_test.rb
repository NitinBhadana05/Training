require "test_helper"

class IssuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    post login_path, params: { email: users(:one).email, password: "password" }
  end

  test "should get new" do
    get new_issue_url
    assert_response :success
  end

  test "should get bills index" do
    get issues_url
    assert_response :success
  end

  test "should show bill" do
    issue = Issue.create!(user: users(:one), book: books(:two), issue_date: Date.current)

    get issue_url(issue)

    assert_response :success
    assert_select "h1", "Bill ##{issue.id}"
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

    assert_redirected_to issue_url(Issue.order(:created_at).last)
    assert_not books(:two).reload.available
    assert_equal "rent", Issue.order(:created_at).last.transaction_type
    assert_equal books(:two).rental_fee, Issue.order(:created_at).last.amount
  end

  test "member issue is created for current user only" do
    delete logout_path
    post login_path, params: { email: users(:two).email, password: "password" }

    assert_difference("Issue.count", 1) do
      post issues_url, params: {
        issue: {
          user_id: users(:one).id,
          book_id: books(:two).id,
          issue_date: Date.current
        }
      }
    end

    assert_equal users(:two), Issue.order(:created_at).last.user
  end

  test "member can return own rental" do
    issue = Issue.create!(user: users(:two), book: books(:two), issue_date: Date.current)
    delete logout_path
    post login_path, params: { email: users(:two).email, password: "password" }

    patch return_book_issue_url(issue)

    assert_redirected_to books_url
    assert issue.reload.return_date.present?
  end

  test "member should not return another member rental" do
    issue = Issue.create!(user: users(:one), book: books(:two), issue_date: Date.current)
    delete logout_path
    post login_path, params: { email: users(:two).email, password: "password" }

    patch return_book_issue_url(issue)

    assert_redirected_to books_url
    assert_nil issue.reload.return_date
  end

  test "member can buy book and bill carries running total" do
    delete logout_path
    post login_path, params: { email: users(:two).email, password: "password" }
    previous_total = users(:two).issues.sum(:amount)

    assert_difference("Issue.count", 1) do
      post issues_url, params: {
        issue: {
          book_id: books(:two).id,
          transaction_type: "buy",
          issue_date: Date.current
        }
      }
    end

    bill = Issue.order(:created_at).last
    assert_redirected_to issue_url(bill)
    assert_equal "buy", bill.transaction_type
    assert_equal books(:two).purchase_price, bill.amount
    assert_equal previous_total, bill.previous_balance
    assert_equal previous_total + books(:two).purchase_price, bill.balance_after
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
