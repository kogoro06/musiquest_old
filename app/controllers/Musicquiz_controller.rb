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
  
    # プレビューURLが存在する曲だけを選択肢に使用
    valid_tracks = @quiz_question.select { |track| track[:preview_url].present? }
  
    # 正解の曲を選択
    @correct_answer = valid_tracks.sample
    @correct_answer_name = @correct_answer[:name]
    @correct_answer_artist = @correct_answer[:artist]
    @correct_answer_preview_url = @correct_answer[:preview_url]
    @correct_answer_album_image = @correct_answer[:album_image]
  
    # 残りの3曲を選択
    remaining_tracks = valid_tracks.reject { |track| track == @correct_answer }.sample(3)
  
    # 正解の曲名と、他の3曲の曲名を合わせて選択肢を作成
    @options = remaining_tracks.map { |track| track[:name] }
    @options << @correct_answer_name
    @options.shuffle!  # 選択肢をシャッフル
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
