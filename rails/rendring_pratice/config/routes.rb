Rails.application.routes.draw do
  
    resources :posts do
    collection do
      get :go_home
      get :check
    end
  end

  namespace :admin do
    get :dashboard
  end

  
 
  root "pages#home"
  get "contact", to: "pages#contact"
  get "user", to: "pages#user"
 
end
