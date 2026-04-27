Rails.application.routes.draw do
  root "pages#home"

  resource :session, only: %i[new create destroy]
  resources :passwords, param: :token
  resources :users
  resources :books do
    member do
      post :rent
      post :buy
    end
  end
  resources :issues do
    member do
      patch :mark_returned
    end
  end
  resources :bills, only: %i[index show edit update]

  get "about", to: "pages#about"
  get "search", to: "books#index", as: :search_books
  get "signup", to: "users#new"
  get "login", to: "sessions#new"
  delete "logout", to: "sessions#destroy"
  get "up" => "rails/health#show", as: :rails_health_check
end
