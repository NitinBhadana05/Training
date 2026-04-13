class HomeController < ApplicationController
  def index
     @message = "Hello Nitin"
     @age = 20
     @time = Time.now

    @posts = Post.all
     
  end

    def about
      @message = "This is about page"
    end 

    def contact
      @email = "test@gmail.com"
    end

    def show
      @post = Post.find(params[:id])

    end

    def search
      @keyword = params[:keyword]

      if @keyword.present?
        @posts = Post.where("title LIKE ?", "%#{@keyword}%")
      else
        @posts = []
      end
    end


    def create
      @post = Post.new(title: params[:title], content: params[:content])
      if @post.save
        redirect_to "/index"
      else
          render :create
      end
    end
end

