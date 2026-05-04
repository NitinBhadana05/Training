Rails.application.routes.draw do
  resources :products
  root "products#index"

  namespace :api do
  resources :products, only: [:index, :show, :create]
end
end
