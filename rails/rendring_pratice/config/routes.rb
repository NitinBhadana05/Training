Rails.application.routes.draw do
  get "tasks/index"
  get "tasks/show"
  get "tasks/new"
  get "tasks/create"
  get "notes/index"
  get "notes/show"
  get "notes/new"
  get "notes/create"
  get "book/index"
  get "book/show"
  
    resources :posts do
    collection do
      get :go_home
      get :check
    end
  end

  namespace :admin do
    get :dashboard
  end

 
  resources :pages

 # root "pages#home"
  #root "sessions#new"

  get "contact", to: "pages#contact"
  get "user", to: "pages#user"
  get "signup", to: "pages#signup"
 
  resources :products
  get '/products/expensive/:price', to: 'products#expensive'

  resources :users do
    resources :pages
  end

  resources :sessions

  resources :parking_sessions, only: [:create, :show] do
    member do
      patch :end_parking
    end

    collection do
      get :active
    end
  end

  resources :payments, only: [:show] do
    member do
      patch :pay
    end
  end
  root "parking_sessions#index"

  resources :books
  resources :notes
  resources :tasks
end
