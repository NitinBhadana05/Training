Rails.application.routes.draw do
  resources :posts
  #get "home/index"
  devise_for :users
  root "home#index"
  
end
