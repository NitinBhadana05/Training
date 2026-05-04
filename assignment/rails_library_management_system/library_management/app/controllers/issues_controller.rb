class IssuesController < ApplicationController
  def index
    issues_scope = Issue.includes(:book, :user).order(issue_date: :desc, created_at: :desc)
    @issues = current_user.admin? ? issues_scope : issues_scope.where(user: current_user)
  end

  def show
    @issue = Issue.includes(:book, :user).find(params[:id])
    unless current_user.admin? || @issue.user == current_user
      redirect_to issues_path, alert: "You can only view your own bills"
      return
    end
  end

  def new
    @issue = Issue.new(issue_defaults_from_params)
    @selected_book = Book.find_by(id: @issue.book_id)
    load_form_collections
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.user = current_user unless current_user.admin?

    if @issue.save
      redirect_to issue_path(@issue), notice: @issue.buy? ? "Book purchased successfully" : "Book rented successfully"
    else
      flash.now[:alert] = @issue.errors.full_messages.to_sentence
      load_form_collections
      render :new, status: :unprocessable_entity
    end
  end

  def return_book
    @issue = Issue.find(params[:id])
    unless current_user.admin? || @issue.user == current_user
      redirect_to books_path, alert: "You can only return your own rentals"
      return
    end

    if @issue.buy?
      redirect_to issue_path(@issue), alert: "Purchased books cannot be returned"
      return
    end

    if @issue.return_date.present?
      redirect_to books_path, alert: "This book has already been returned"
      return
    end

    if @issue.update(return_date: Date.today)
      load_dashboard_data

      respond_to do |format|
        format.turbo_stream { render_dashboard_streams("Book returned successfully") }
        format.html { redirect_to books_path, notice: "Book returned successfully" }
      end
    else
      redirect_to books_path, alert: "Failed to return book"
    end
  end

  private

  def load_dashboard_data
    @books = Book.includes(issues: :user).order(created_at: :desc).limit(8)
    active_issues_scope = Issue.includes(:book, :user).where(transaction_type: "rent", return_date: nil).order(issue_date: :desc)
    @active_issues = current_user.admin? ? active_issues_scope : active_issues_scope.where(user: current_user)
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

  def load_form_collections
    @users = User.order(:name) if current_user.admin?
    @available_books = Book.where(available: true).order(:title)
  end

  def issue_params
    allowed_params = [:book_id, :issue_date, :transaction_type]
    allowed_params << :user_id if current_user.admin?
    params.require(:issue).permit(allowed_params)
  end

  def issue_defaults_from_params
    return {} unless params[:issue]

    params.require(:issue).permit(:book_id, :transaction_type)
  end

  def render_dashboard_streams(message)
    flash.now[:notice] = message

    render turbo_stream: [
      turbo_stream.replace("flash", partial: "shared/flash"),
      turbo_stream.replace("catalog_stats", partial: "books/stats", locals: { stats: @stats }),
      turbo_stream.replace("catalog_results", partial: "books/catalog_results", locals: { books: @books }),
      turbo_stream.replace("active_loans", partial: "books/active_loans", locals: { active_issues: @active_issues })
    ]
  end
end
