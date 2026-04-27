require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
  end

  test "redirects unauthenticated users" do
    get books_url
    assert_redirected_to new_session_path
  end

  test "shows books to signed in users" do
    sign_in_as(users(:one))

    get books_url
    assert_response :success

    get book_url(@book)
    assert_response :success
  end

  test "allows admins to access new book page" do
    sign_in_as(users(:admin))

    get new_book_url
    assert_response :success
  end

  test "allows admins to update books" do
    sign_in_as(users(:admin))

    patch book_url(@book), params: {
      book: {
        title: "Updated Title",
        author: @book.author,
        isbn: @book.isbn,
        category: @book.category,
        description: @book.description,
        total_copies: @book.total_copies,
        available_copies: @book.available_copies,
        daily_rent: @book.daily_rent,
        purchase_price: @book.purchase_price,
        active: @book.active
      }
    }

    assert_redirected_to book_path(@book)
    assert_equal "Updated Title", @book.reload.title
  end
end
