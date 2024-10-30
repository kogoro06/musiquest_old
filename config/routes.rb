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
  get "musicquiz/genre", to: "musicquiz#genre", as: :musicquiz_genre
  get "musicquiz/work", to: "musicquiz#work", as: :musicquiz_work
  get "musicquiz/artist", to: "musicquiz#artist", as: :musicquiz_artist
  get "musicquiz/era", to: "musicquiz#era", as: :musicquiz_era
  get "musicquiz/ranking", to: "musicquiz#ranking", as: :musicquiz_ranking
  get "musicquiz/playlist", to: "musicquiz#playlist", as: :musicquiz_playlist

  # お気に入り登録機能のルート

  # 登録機能のルート

  # Deviseのルート設定
  devise_for :users

  # ルートパス設定
  root "static_pages#top"
end
