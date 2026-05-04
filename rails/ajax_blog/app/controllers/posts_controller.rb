class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show]
  before_action :set_owned_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user, :likes).order(created_at: :desc).page(params[:page]).per(6)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      enqueue_post_job(@post.id)
      redirect_to @post, notice: "Post created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted successfully"
  end

  private

  def set_post
    @post = Post.includes(:user, :likes).friendly.find(params[:id])
  end

  def set_owned_post
    @post = current_user.posts.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def enqueue_post_job(post_id)
    PostJob.perform_async(post_id)
  rescue RedisClient::CannotConnectError => error
    Rails.logger.warn("Skipping PostJob enqueue for post #{post_id}: #{error.message}")
  end
end
