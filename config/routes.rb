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

  # ジャンル別のルート設定
  get 'musicquiz/genre/jpop', to: 'musicquiz#genre_jpop', as: :musicquiz_genre_jpop
  get 'musicquiz/genre/kpop', to: 'musicquiz#genre_kpop', as: :musicquiz_genre_kpop
  get 'musicquiz/genre/hiphop', to: 'musicquiz#genre_hiphop', as: :musicquiz_genre_hiphop
  get 'musicquiz/genre/anime', to: 'musicquiz#genre_anime', as: :musicquiz_genre_anime
  get 'musicquiz/genre/anime/play', to: 'musicquiz#play_anime', as: :musicquiz_play_anime

  post 'musicquiz/check_answer/:id', to: 'musicquiz#check_answer', as: 'check_answer'

  # Spotifyのコールバックルート
  get '/auth/spotify/callback', to: 'users#spotify'

  # Defines the root path route ("/")
  root "static_pages#top"
  devise_for :users
end
