Rails.application.routes.draw do
  resources :customers
  resources :videos
  resources :hooks, only: [:create]
end
