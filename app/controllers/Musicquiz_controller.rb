require 'rspotify'
require 'json'
require 'base64'

class MusicquizController < ApplicationController
  # コールバックアクション
  def callback
    # Spotify認証結果を受け取る
    @user = RSpotify::User.new(request.env['omniauth.auth'])
    if @user.nil?
      flash[:alert] = "Spotify認証に失敗しました。"
      redirect_to root_path and return
    end

    Rails.logger.info("Access Token: #{@user.credentials.token}")

    # セッションにSpotifyトークンとユーザー情報を保存
    session[:spotify_user] = @user.to_hash
    session[:spotify_token] = @user.credentials.token

    # クイズ開始ページにリダイレクト
    redirect_to musicquiz_start_path, notice: "Spotify認証に成功しました！"
  end

  # アニメクイズをプレイするアクション
  def play_anime
    # セッションからトークンを取得
    token = session[:spotify_token]

    if token.nil?
      flash[:alert] = "Spotifyにログインしてください。"
      redirect_to '/auth/spotify' and return
    end

    Rails.logger.info("Using token: #{token}")

    # Spotifyからアニメジャンルの曲を取得
    @quiz_question = get_spotify_tracks('アニメ')

    Rails.logger.info("Quiz question: #{@quiz_question.inspect}")

    # @quiz_questionが空でないことを確認
    if @quiz_question.nil? || @quiz_question.empty?
      flash.now[:alert] = "クイズの問題が取得できませんでした。再試行してください。"
      render :play_anime and return
    end

    @options = @quiz_question.sample(4)  # 取得した曲の中からランダムに選択
  end

  private

  # Spotifyから楽曲を取得（RSpotifyを利用）
  def get_spotify_tracks(genre)
    begin
      # ジャンルで検索（例: "アニメ"）
      tracks = RSpotify::Track.search(genre, limit: 10)
      
      # トラック情報を抽出
      tracks.map do |track|
        {
          name: track.name,
          artist: track.artists.first.name,
          preview_url: track.preview_url,
          album_image: track.album.images.first['url']
        }
      end
    rescue StandardError => e
      Rails.logger.error("Error fetching Spotify tracks: #{e.message}")
      []
    end
  end
end
