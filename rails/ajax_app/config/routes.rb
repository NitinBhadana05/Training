Rails.application.routes.draw do
  get "posts/index"
  get "posts/new"
  get "posts/create"
  
  resources :books
  #root "books#index"
  
  resources :users
  get "/check_email", to: "users#check_email"
  root "users#index"
  
  #resources :posts
  resources :posts do
    member do
      post :like
    end
  end
 # root "posts#index"
  


end
