# app/services/spotify_service.rb

require 'rest-client'
require 'json'

class SpotifyService
  def self.get_access_token(code)
    response = RestClient.post("https://accounts.spotify.com/api/token", {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: 'http://localhost:3000/callback',
      client_id: ENV['SPOTIFY_CLIENT_ID'],
      client_secret: ENV['SPOTIFY_CLIENT_SECRET']
    })

    token_data = JSON.parse(response.body)
    {
      access_token: token_data['access_token'],
      refresh_token: token_data['refresh_token'],
      expires_in: token_data['expires_in']
    }
  end

  def self.refresh_access_token(refresh_token)
    response = RestClient.post("https://accounts.spotify.com/api/token", {
      grant_type: 'refresh_token',
      refresh_token: refresh_token,
      client_id: ENV['SPOTIFY_CLIENT_ID'],
      client_secret: ENV['SPOTIFY_CLIENT_SECRET']
    })

    token_data = JSON.parse(response.body)
    {
      access_token: token_data['access_token'],
      expires_in: token_data['expires_in']
    }
  end

  def self.get_spotify_tracks(genres)
    genre_queries = {
      'アニメ' => ERB::Util.url_encode('アニメ OR anime'),
      'ディズニー' => ERB::Util.url_encode('ディズニー OR disney'),
      '特撮' => ERB::Util.url_encode('仮面ライダー OR スーパー戦隊 OR ウルトラマン OR tokusatsu')
    }

    genres.flat_map do |genre|
      query = genre_queries[genre]
      next [] unless query

      RSpotify::Track.search(query, limit: 50, market: 'JP').map do |track|
        {
          name: track.name,
          artist: track.artists.first.name,
          preview_url: track.preview_url,
          album_image: track.album.images.first['url'],
          popularity: track.popularity
        }
      end
    end
  end

  def self.get_user_info(token)
    response = RestClient.get("https://api.spotify.com/v1/me", {
      Authorization: "Bearer #{token}"
    })
    JSON.parse(response.body)
  end
end
