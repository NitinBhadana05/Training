class PostMailer < ApplicationMailer
  def post_created(post)
    @post = post
    mail(to: @post.user.email, subject: "New Post Created")
  end
end