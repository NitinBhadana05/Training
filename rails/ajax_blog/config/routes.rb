Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root "posts#index"

  resources :posts do
    resource :like, only: [:create, :destroy]
  end
end
