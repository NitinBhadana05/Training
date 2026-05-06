Rails.application.routes.draw do
  resources :dashboard
  resources :bounties
  resources :hunters
  resources :missions
  root "dashboard#index"
end
