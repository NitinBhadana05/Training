class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc).limit(10).offset(params[:offset].to_i)
    @post = Post.new

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  def create
    @post = Post.new(post_params)
    @post.save

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end

  def destroy
    @post = Post.find(params[:id])

    @post.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end

  def like
    @post = Post.find(params[:id])

    if @post.liked
      @post.decrement!(:likes)
      @post.update(liked: false)
    else
      @post.increment!(:likes)
      @post.update(liked: true)
    end

    render json: { likes: @post.likes, liked: @post.liked }
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end