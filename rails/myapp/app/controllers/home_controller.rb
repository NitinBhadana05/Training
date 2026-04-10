class HomeController < ApplicationController
  def index
     @message = "Hello Nitin"
     @age = 20
     @time = Time.now

    
     
  end
end

