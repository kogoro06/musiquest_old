require 'httparty'
class SpotifyService
  BASE_URL = "https://api.spotify.com/v1"

  def self.get_spotify_tracks(genres)
    # 省略: 既存のジャンルクエリなどを設定

    # Spotify APIを呼び出してトラックを取得するロジックを実装
  end

  def self.get_top_tracks
    # Spotify APIを呼び出してTop 50のデータを取得する処理
    response = HTTParty.get("#{BASE_URL}/charts/top", headers: { "Authorization" => "Bearer #{access_token}" })
    
    if response.success?
      return response.parsed_response["tracks"]
    else
      Rails.logger.error("Failed to fetch top tracks: #{response.body}")
      return []
    end
  end

  def self.get_viral_tracks
    # Spotify APIを呼び出してViral 50のデータを取得する処理
    response = HTTParty.get("#{BASE_URL}/charts/viral", headers: { "Authorization" => "Bearer #{access_token}" })
    
    if response.success?
      return response.parsed_response["tracks"]
    else
      Rails.logger.error("Failed to fetch viral tracks: #{response.body}")
      return []
    end
  end

  private

  def self.access_token
    # Spotifyのアクセストークンを取得するためのメソッドを実装
    # 省略: 実装方法によって異なる
  end

  def self.get_user_playlists(user)
    RSpotify::User.find(user.spotify_user_id).playlists
  rescue StandardError => e
    Rails.logger.error("Spotify APIエラー - プレイリスト取得時: #{e.message}")
    []
  end
  def self.get_tracks_from_playlist(playlist_id)
    playlist = RSpotify::Playlist.find(playlist_id)
    playlist.tracks.map do |track|
      {
        name: track.name,
        artist: track.artists.first.name,
        preview_url: track.preview_url,
        album_image: track.album.images.first['url'],
        popularity: track.popularity
      }
    end
  rescue StandardError => e
    Rails.logger.error("Spotify APIエラー - プレイリストのトラック取得時: #{e.message}")
    []
  end
end
