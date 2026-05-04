module ApplicationHelper
  def can_manage_post?(post)
    user_signed_in? && post.user_id == current_user.id
  end

  def current_like_for(post)
    if user_signed_in?
      post.likes.find { |like| like.user_id == current_user.id }
    else
      post.likes.find { |like| like.guest_token == current_guest_token }
    end
  end

  def liked_post?(post)
    current_like_for(post).present?
  end
end
