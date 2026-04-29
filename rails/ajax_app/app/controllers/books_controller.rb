class BooksController < ApplicationController
  def index
    if params[:query].present?
      @books = Book.where("title like :q OR auther LIKE :q", q: "%#{params[:query]}%")
    else
     @books = Book.all
    end

    respond_to do |format|
      format.html
      format.json { render json: @books }
    end
  end

  def show
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(form_data)

    if @book.save
      redirect_to @book, notice: "Book created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(form_data)
      redirect_to books_path, notice: "Book updated"
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    redirect_to book_path, notice: "Book Deleted"
  end

  private

  def form_data
    params.require(:book).permit(:title, :auther)
  end
end
