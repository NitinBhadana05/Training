class IssuesController < ApplicationController
  def new
    @issue = Issue.new
    load_form_collections
  end

  def create
    @issue = Issue.new(issue_params)

    if @issue.save
      redirect_to books_path, notice: "Book issued successfully"
    else
      flash.now[:alert] = @issue.errors.full_messages.to_sentence
      load_form_collections
      render :new, status: :unprocessable_entity
    end
  end

  def return_book
    @issue = Issue.find(params[:id])

    if @issue.return_date.present?
      redirect_to books_path, alert: "This book has already been returned"
      return
    end

    if @issue.update(return_date: Date.today)
      redirect_to books_path, notice: "Book returned successfully"
    else
      redirect_to books_path, alert: "Failed to return book"
    end
  end

  private

  def load_form_collections
    @users = User.order(:name)
    @available_books = Book.where(available: true).order(:title)
  end

  def issue_params
    params.require(:issue).permit(:user_id, :book_id, :issue_date)
  end
end
