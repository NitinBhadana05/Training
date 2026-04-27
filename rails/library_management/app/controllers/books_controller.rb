class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy rent buy]
  before_action :require_admin!, only: %i[new create edit update destroy]

  def index
    @query = params[:query]
    @selected_category = params[:category]
    @selected_availability = params[:availability]
    @books = Book.filtered(params)
    @categories = Book.distinct.order(:category).pluck(:category).compact_blank
  end

  def show
  end

  def new
    @book = Book.new(active: true, total_copies: 1, available_copies: 1)
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to @book, notice: "Book added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book removed successfully.", status: :see_other
  rescue ActiveRecord::DeleteRestrictionError, ActiveRecord::RecordNotDestroyed
    redirect_to @book, alert: "Book cannot be removed while issue records exist."
  end

  def rent
    issue = @book.rent_to!(user: current_user)
    redirect_to issue_path(issue), notice: "Book rented successfully."
  rescue ActiveRecord::RecordInvalid
    redirect_to @book, alert: "Unable to rent this book right now."
  end

  def buy
    issue = @book.sell_to!(user: current_user)
    redirect_to issue_path(issue), notice: "Book purchased successfully."
  rescue ActiveRecord::RecordInvalid
    redirect_to @book, alert: "Unable to purchase this book right now."
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(
        :title, :author, :isbn, :category, :description, :total_copies,
        :available_copies, :daily_rent, :purchase_price, :active
      )
    end
end
