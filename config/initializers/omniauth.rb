Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'],
           scope: 'playlist-read-private user-read-private user-read-email user-modify-playback-state user-read-playback-state',
           redirect_uri: 'http://localhost:3000/callback'
end
