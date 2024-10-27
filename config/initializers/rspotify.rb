require 'rspotify'
require 'dotenv/load'  # 環境変数をロードするためにdotenvを読み込み

# Spotify APIの認証情報を設定（グローバル認証）
RSpotify::authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

# OmniAuthを使ったユーザー認証の設定
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'], scope: 'user-read-email playlist-modify-public user-library-read user-library-modify'
end
