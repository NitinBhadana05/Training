require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    post login_path, params: { email: users(:one).email, password: "password" }
  end

  test "should get index" do
    get books_url
    assert_response :success
  end

  test "should get show" do
    get book_url(books(:one))
    assert_response :success
  end

  test "should get new" do
    get new_book_url
    assert_response :success
  end

  test "should create book" do
    assert_difference("Book.count", 1) do
      post books_url, params: {
        book: {
          title: "Domain-Driven Design",
          author: "Eric Evans",
          isbn: "ISBN-003"
        }
      }
    end

    assert_redirected_to books_url
  end
end
