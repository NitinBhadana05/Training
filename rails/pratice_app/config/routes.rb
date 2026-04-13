Rails.application.routes.draw do
  get "users", to: "users#index"
  get "users/new", to: "users#new"
  post "users", to: "users#create"
  get "users/:id", to: "users#show"
  get "users/:id/edit", to: "users#edit"
  patch "users/:id", to: "users#update"
  delete "users/:id", to: "users#destroy"

  root "users#index"
end