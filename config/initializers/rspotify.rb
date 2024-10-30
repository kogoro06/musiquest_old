require 'rspotify'

# 環境変数がnilの場合はエラーを発生させる
if ENV['SPOTIFY_CLIENT_ID'].nil? || ENV['SPOTIFY_CLIENT_SECRET'].nil?
  raise "SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET must be set."
end

# RSpotifyの認証
begin
  RSpotify::authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
rescue RestClient::ExceptionWithResponse => e
  puts "Error during RSpotify authentication: #{e.response}"
end
