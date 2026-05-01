
class PostNotificationJob < ApplicationJob
  queue_as :default

  def perform(post_id)
     post = Post.find(post_id)
    #puts "Post created: #{post.title}"
     PostMailer.post_created(post).deliver_now
  end
end