module SpotifyTokenManager
  extend ActiveSupport::Concern

  private

  def refresh_spotify_token
    refresh_token = session[:spotify_refresh_token]

    unless refresh_token
      Rails.logger.error("リフレッシュトークンが見つかりません。")
      flash[:alert] = "Spotifyに再ログインしてください。"
      redirect_to new_user_session_path and return
    end

    response = HTTParty.post("https://accounts.spotify.com/api/token", {
      body: {
        grant_type: 'refresh_token',
        refresh_token: refresh_token,
        client_id: ENV['SPOTIFY_CLIENT_ID'],
        client_secret: ENV['SPOTIFY_CLIENT_SECRET']
      },
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
    })

    if response.success?
      session[:spotify_token] = response.parsed_response["access_token"]
      session[:spotify_token_expires_at] = Time.now + response.parsed_response["expires_in"].to_i
    else
      Rails.logger.error("トークンのリフレッシュ失敗: #{response.body}")
      flash[:alert] = "Spotifyのトークンのリフレッシュに失敗しました。"
      redirect_to new_user_session_path
    end
  end

  def token_valid?
    session[:spotify_token].present? && session[:spotify_token_expires_at] > Time.now
  end

  def some_spotify_api_call
    refresh_spotify_token unless token_valid?

    response = HTTParty.get("https://api.spotify.com/v1/me", headers: {
      "Authorization" => "Bearer #{session[:spotify_token]}"
    })

    if response.success?
      return response.parsed_response
    else
      Rails.logger.error("Spotify API呼び出し失敗: #{response.body}")
      flash[:alert] = "Spotify APIへのアクセスに失敗しました。"
      redirect_to new_user_session_path
    end
  end
end