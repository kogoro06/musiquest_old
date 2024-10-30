Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"

  get "introduce/index"
  get "homes/top"
  get "static_pages/top"
  get 'introduce', to: 'introduce#index', as: :introduce

  get "musicquiz/start", to: "musicquiz#start", as: :musicquiz_start
  get "musicquiz/genre", to: "musicquiz#genre", as: :musicquiz_genre
  get "musicquiz/work", to: "musicquiz#work", as: :musicquiz_work
  get "musicquiz/artist", to: "musicquiz#artist", as: :musicquiz_artist
  get "musicquiz/era", to: "musicquiz#era", as: :musicquiz_era
  get "musicquiz/ranking", to: "musicquiz#ranking", as: :musicquiz_ranking
  get "musicquiz/playlist", to: "musicquiz#playlist", as: :musicquiz_playlist
  get "musicquiz/online_battle", to: "musicquiz#online_battle", as: :musicquiz_online_battle

  get "musicquiz/correct_tracks", to: "musicquiz#correct_tracks", as: :musicquiz_correct_tracks
  get "musicquiz/user_rankings", to: "musicquiz#user_rankings", as: :musicquiz_user_rankings
  get "musicquiz/online_mode", to: "musicquiz#online_mode", as: :musicquiz_online_mode

  # 音楽ジャンルのルーティング
  get "genre/play/jpop", to: "genre#play_jpop", as: :genre_play_jpop
  get "genre/play/kpop", to: "genre#play_kpop", as: :genre_play_kpop
  get "genre/play/westernmusic", to: "genre#play_westernmusic", as: :genre_play_westernmusic
  get "genre/play/hiphop", to: "genre#play_hiphop", as: :genre_play_hiphop
  get "genre/play/anime", to: "genre#play_anime", as: :genre_play_anime

  devise_for :users

  root "static_pages#top"
end
