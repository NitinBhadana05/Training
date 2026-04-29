class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @query = params[:q].to_s.strip
    @books = Book.includes(issues: :user).order(created_at: :desc)
    @books = @books.where(
      "title LIKE :query OR author LIKE :query OR isbn LIKE :query",
      query: "%#{@query}%"
    ) if @query.present?

    @active_issues = Issue.includes(:book, :user).where(return_date: nil).order(issue_date: :desc)
    @stats = {
      total_books: Book.count,
      available_books: Book.where(available: true).count,
      issued_books: Book.where(available: false).count,
      members: User.count
    }
  end

  def show
    @active_issue = @book.active_issue
    @issue_history = @book.issues.includes(:user).order(issue_date: :desc)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to books_path, notice: "Book created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to books_path, notice: "Book updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book deleted"
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :isbn)
  end
end
