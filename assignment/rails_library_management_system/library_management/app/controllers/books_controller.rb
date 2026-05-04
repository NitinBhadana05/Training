class BooksController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    load_dashboard_data
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
      load_dashboard_data

      respond_to do |format|
        format.turbo_stream { render_dashboard_streams("Book created") }
        format.html { redirect_to books_path, notice: "Book created" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "quick_new_book",
            partial: "books/quick_new_book",
            locals: { book: @book }
          ), status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_entity }
      end
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
    load_dashboard_data

    respond_to do |format|
      format.turbo_stream { render_dashboard_streams("Book deleted") }
      format.html { redirect_to books_path, notice: "Book deleted" }
    end
  end

  private

  def load_dashboard_data
    @query = params[:q].to_s.strip
    @show_all_books = params[:view] == "books" || @query.present?

    books_scope = Book.includes(issues: :user).order(created_at: :desc)
    books_scope = books_scope.where(
      "title LIKE :query OR author LIKE :query OR isbn LIKE :query",
      query: "%#{@query}%"
    ) if @query.present?
    @books = @show_all_books ? books_scope : books_scope.limit(8)

    active_issues_scope = Issue.includes(:book, :user).where(return_date: nil).order(issue_date: :desc)
    @active_issues = current_user.admin? ? active_issues_scope : active_issues_scope.where(user: current_user)
    @book = Book.new
    @stats = if current_user.admin?
      {
        total_books: Book.count,
        available_books: Book.where(available: true).count,
        issued_books: Book.where(available: false).count,
        members: User.count
      }
    else
      {
        available_books: Book.where(available: true).count,
        my_active_rentals: current_user.issues.where(transaction_type: "rent", return_date: nil).count,
        my_bills: current_user.issues.count,
        my_total_billed: current_user.issues.sum(:amount)
      }
    end
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :isbn, :rental_fee, :purchase_price)
  end

  def render_dashboard_streams(message)
    flash.now[:notice] = message

    render turbo_stream: [
      turbo_stream.replace("flash", partial: "shared/flash"),
      turbo_stream.replace("quick_new_book", partial: "books/quick_new_book", locals: { book: Book.new }),
      turbo_stream.replace("catalog_stats", partial: "books/stats", locals: { stats: @stats }),
      turbo_stream.replace("catalog_results", partial: "books/catalog_results", locals: { books: @books }),
      turbo_stream.replace("active_loans", partial: "books/active_loans", locals: { active_issues: @active_issues })
    ]
  end
end
