Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :posts
  #get "home/index"
  devise_for :users
  #root "home#index"

  namespace :api do
    resources :posts
  end

  resources :users, only: [:show]
  resources :products
  root "products#index"
  
end
