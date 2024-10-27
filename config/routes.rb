Rails.application.routes.draw do
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

  # クイズの結果を表示するアクション
  get 'musicquiz/genre/anime/result', to: 'musicquiz#show_result', as: :show_result

  # Spotify認証のルート
  get '/auth/spotify', to: 'musicquiz#callback'
  get '/auth/spotify/callback', to: 'musicquiz#callback'
  get 'final_results', to: 'musicquiz#final_results', as: :final_results
  
  # Deviseのルート設定
  devise_for :users

  # ルートパス設定
  root "static_pages#top"
end
