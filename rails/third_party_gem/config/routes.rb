Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :posts
  #get "home/index"
  devise_for :users
  root "home#index"

  namespace :api do
    resources :posts
  end

  
end
