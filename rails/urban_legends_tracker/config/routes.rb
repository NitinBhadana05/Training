# config/routes.rb
Rails.application.routes.draw do
  resources :legends
  root "legends#index"
end