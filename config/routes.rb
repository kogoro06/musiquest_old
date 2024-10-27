Rails.application.routes.draw do
  get "introduce/index"
  get "homes/top"
  get "musicquiz/start", to: "musicquiz#start", as: :musicquiz_start
  get "static_pages/top"
  get 'introduce', to: 'introduce#index', as: :introduce
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get 'musicquiz/genre', to: 'musicquiz#genre', as: 'musicquiz_genre'
  get 'musicquiz/work', to: 'musicquiz#work', as: 'musicquiz_work'
  get 'musicquiz/artist', to: 'musicquiz#artist', as: 'musicquiz_artist'

  # Defines the root path route ("/")
  # root "posts#index"
  root "static_pages#top"
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end