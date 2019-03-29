Rails.application.routes.draw do
  resources :customers do 
    member do 
      get :is_watching_now
    end
  end
  resources :videos do 
    member do 
      get :current_watchmans
    end
  end
  resources :hooks, only: [:create]
end
