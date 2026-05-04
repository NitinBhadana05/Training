class LikesController < ApplicationController
  before_action :set_post

  def create
    @like = @post.likes.find_or_create_by(visitor_like_attributes)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post }
    end
  end

  def destroy
    @like = @post.likes.find_by(visitor_like_attributes)
    @like&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post }
    end
  end

  private

  def set_post
    @post = Post.friendly.find(params[:post_id])
  end

  def visitor_like_attributes
    if user_signed_in?
      { user: current_user }
    else
      { guest_token: current_guest_token }
    end
  end
end
