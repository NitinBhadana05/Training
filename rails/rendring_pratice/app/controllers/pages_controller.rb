class PagesController < ApplicationController  
  
  
  #before_action :check_user
  def check_user
      unless params[:token] == "123"
        render plain: "Unauthorized access"
      end
  end


  #layout "mailer"
  def home
   @user = NewUser.find_by(email: params[:email], password: params[:password])

  end

  def contact
  end

  def user
     @users = User.all
     
  end

  def signup
    @user = User.new
  end
end

class PostsController < ApplicationController

  def create
    user = User.find_by(id: params[:user_id])

    return render plain: "User not found" unless user

    post = user.posts.new(post_params)

    if post.save
      render plain: "Post created: #{post.title} for User #{user.name}"
    else
      render plain: post.errors.full_messages.join(", ")
    end
  end

  private

  def post_params
    params.require(:post).permit(:title)
  end

 
    

end

