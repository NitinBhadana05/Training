# config/routes.rb
Rails.application.routes.draw do
  resources :legends
  root "legends#index"

  namespace :api do
    namespace :v1 do
      resources :legends, only: [:index, :show]
    end
  end
end