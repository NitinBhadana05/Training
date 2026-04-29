Rails.application.routes.draw do
  get "posts/index"
  get "posts/new"
  get "posts/create"
  
  resources :books
  #root "books#index"
  
  resources :users
  ##root "users#index"
  
  resources :posts
  root "posts#index"
  


end
