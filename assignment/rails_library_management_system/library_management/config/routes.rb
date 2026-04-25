Rails.application.routes.draw do

  # 🔐 Authentication
  get    "/signup", to: "users#new"
  post   "/users",  to: "users#create"

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  #  Books
  resources :books

  #  Users
  resources :users, only: [:index]

  # Issues (borrow/return)
  resources :issues, only: [:new, :create] do
    member do
      patch :return_book
    end
  end

  # Home
  root "books#index"

end