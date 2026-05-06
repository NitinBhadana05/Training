

Rails.application.routes.draw do


  root "explorers#index"

  resources :explorers do
    resources :artifacts
  end

  namespace :api do
    namespace :v1 do
      resources :artifacts, only: [:index, :show]
      resources :explorers, only: [:index, :show]
    end
  end
end