Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  # 既存のルート設定
  get "introduce/index"
  get "homes/top"
  get "static_pages/top"
  get 'introduce', to: 'introduce#index', as: :introduce

  # Musicquiz関連のルート
  get "musicquiz/start", to: "musicquiz#start", as: :musicquiz_start
  get "musicquiz/genre", to: "musicquiz#genre"
  get "musicquiz/work", to: "musicquiz#work"
  get "musicquiz/artist", to: "musicquiz#artist"
  get "musicquiz/era", to: "musicquiz#era"
  get "musicquiz/ranking", to: "musicquiz#ranking"
  get "musicquiz/playlist", to: "musicquiz#playlist"

  # ジャンル別クイズページのルート（汎用化したplayルート）
  get 'musicquiz/play/:genre', to: 'musicquiz#play', as: :musicquiz_play

  # Spotify認証のルート
  get '/auth/spotify', to: 'sessions#new'  # 認証を開始するルート
  get '/auth/spotify/callback', to: 'sessions#create'  # 認証後に戻ってくるルート

  # クイズの開始、結果、ユーザー情報関連のルート
  get 'musicquiz/setup_new_question', to: 'musicquiz#setup_new_question'
  get '/musicquiz/play', to: 'musicquiz#play'
  get '/musicquiz/result', to: 'musicquiz#show_result',as: :show_result
  get '/musicquiz/final_results', to: 'musicquiz#final_results', as: :final_results
  get '/musicquiz/user_info', to: 'musicquiz#user_info'

  # Deviseのルート設定
  devise_for :users

  # ルートパス設定
  root "static_pages#top"
end