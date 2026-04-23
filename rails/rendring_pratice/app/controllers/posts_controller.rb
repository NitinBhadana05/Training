class PostsController < ApplicationController

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])

    # Example of render (explicit)
    render :show
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      # redirect_to example
      redirect_to posts_path
    else
      render :index
    end
  end

  def go_home
    redirect_to posts_path
  end

  def check
    head :ok
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end