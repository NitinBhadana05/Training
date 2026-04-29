Rails.application.routes.draw do
  
  resources :books
  #root "books#index"
  
  resources :users
  root "users#index"
end
