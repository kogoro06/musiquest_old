class SpotifyService
  def self.get_spotify_tracks(genres)
    genre_queries = {
      'アニメ' => ERB::Util.url_encode('アニメ OR anime'),
      'ディズニー' => ERB::Util.url_encode('ディズニー OR disney'),
      '特撮' => ERB::Util.url_encode('仮面ライダー OR スーパー戦隊 OR ウルトラマン OR tokusatsu')
    }
  
    tracks = genres.flat_map do |genre|
      query = genre_queries[genre]
      next [] unless query
  
      begin
        Rails.logger.debug("Spotify APIリクエスト - ジャンル: #{genre}, クエリ: #{query}")
        results = RSpotify::Track.search(query, limit: 50, market: 'JP').map do |track|
          {
            name: track.name,
            artist: track.artists.first.name,
            preview_url: track.preview_url,
            album_image: track.album.images.first['url'],
            popularity: track.popularity
          }
        end
        Rails.logger.debug("Spotify API検索結果 - ジャンル: #{genre}, 結果数: #{results.size}")
        results
      rescue RestClient::ExceptionWithResponse => e
        Rails.logger.error("Spotify APIエラー - ジャンル: #{genre}, エラー: #{e.response}")
        []
      end
    end
  
    # プレビューURLがあるトラックを選択し、人気順にソート
    tracks.select { |track| track[:preview_url].present? }.sort_by { |track| -track[:popularity] }
  end
end