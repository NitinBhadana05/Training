Rails.application.routes.draw do

  # 🔐 Authentication
  get    "/signup", to: "users#new"
  post   "/users",  to: "users#create"

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  get    "/forgot_password", to: "password_resets#new", as: :new_password_reset
  post   "/forgot_password", to: "password_resets#create", as: :password_reset
  get    "/password_reset/edit", to: "password_resets#edit", as: :edit_password_reset
  patch  "/password_reset", to: "password_resets#update"
  delete "/logout", to: "sessions#destroy"

  #  Books
  resources :books

  #  Users
  resources :users, only: [:index]

  # Issues (borrow/return)
  resources :issues, only: [:index, :show, :new, :create] do
    member do
      patch :return_book
    end
  end

  # Home
  root "books#index"

end
