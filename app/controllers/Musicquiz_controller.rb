require 'rest-client'
require 'json'

class MusicquizController < ApplicationController
  before_action :refresh_spotify_token, only: [:play, :start, :user_info]

  # Spotify認証後のコールバック
  def callback
    code = params[:code]
    begin
      response = RestClient.post("https://accounts.spotify.com/api/token", {
        grant_type: 'authorization_code',
        code: code,
        redirect_uri: 'http://localhost:3000/callback',
        client_id: ENV['SPOTIFY_CLIENT_ID'],
        client_secret: ENV['SPOTIFY_CLIENT_SECRET']
      })

      token_data = JSON.parse(response.body)
      session[:spotify_token] = token_data['access_token']
      session[:spotify_refresh_token] = token_data['refresh_token']
      session[:spotify_token_expires_at] = Time.now + token_data['expires_in'].to_i

      Rails.logger.info("Access Token: #{session[:spotify_token]}")
      Rails.logger.info("Refresh Token: #{session[:spotify_refresh_token]}")

      redirect_to musicquiz_start_path, notice: "Spotify認証に成功しました！"
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("トークンの取得に失敗しました: #{e.response}")
      redirect_to root_path, alert: "Spotify認証に失敗しました。"
    end
  end

  # クイズプレイ画面
  def play
  # refresh_spotify_token

  # 初回プレイ時にセッションをリセット
  if session[:current_question].nil?
    session[:current_question] = 1
    session[:correct_count] = 0
    session[:played_songs] = []
    session[:genre] = params[:genre] if params[:genre].present?
  end

  # 10問プレイ後は結果画面へリダイレクト
  if session[:current_question] > 10
    redirect_to final_results_path and return
  end

  # トラック情報の取得と問題設定
  selected_genres = session[:genre] ? [session[:genre]] : ['アニメ', 'ディズニー', '特撮']
  available_tracks = get_spotify_tracks(selected_genres)
  played_songs = session[:played_songs]
  available_tracks.reject! { |track| played_songs.include?(track[:name]) }

  if available_tracks.size < 4
    flash.now[:alert] = "十分な数の曲を取得できませんでした。再試行してください。"
    render :play and return
  end

  # 問題の設定
  @correct_answer = available_tracks.sample
  session[:correct_answer] = {
    name: @correct_answer[:name],
    artist: @correct_answer[:artist],
    preview_url: @correct_answer[:preview_url],
    album_image: @correct_answer[:album_image]
  }

  # 残りの曲から3曲をランダムに選択
  remaining_tracks = available_tracks.reject { |track| track == @correct_answer }.sample(3)
  @options = (remaining_tracks.map { |track| track[:name] } << @correct_answer[:name]).shuffle

  # ログに選択肢情報を表示
  Rails.logger.info("選択肢: #{@options.inspect}")

  # ボタンのラベル情報を出力
  @options.each do |option|
    Rails.logger.info("ボタンラベル: #{option}")
  end

  Rails.logger.info("正解のトラック情報: #{session[:correct_answer].inspect}")
  session[:played_songs] << @correct_answer[:name]
end

 # クイズ結果表示
 def show_result
  correct_answer = session[:correct_answer]
  if correct_answer.nil?
    flash[:alert] = "クイズのデータが見つかりませんでした。"
    redirect_to root_path and return
  end

  # 選択した曲名を取得
  @selected_answer = params[:commit]  # commitはユーザーが押したボタンのラベル

  # 正解の曲名とアーティストをセッションから取得
  @correct_answer_name = correct_answer[:name]
  @correct_answer_artist = correct_answer[:artist]
  @correct_answer_preview_url = correct_answer[:preview_url]
  @correct_answer_album_image = correct_answer[:album_image]

  # 選択した曲名と正解の曲名を比較
  @is_correct = @selected_answer == @correct_answer_name

  Rails.logger.info("選択した曲: #{@selected_answer}")
  Rails.logger.info("正解の曲名: #{@correct_answer_name}")

  # 正解数と問題数のカウント
  session[:correct_count] ||= 0
  session[:correct_count] += 1 if @is_correct
  session[:current_question] ||= 1
  session[:current_question] += 1
end

  # 最終結果表示
  def final_results
    @correct_count = session[:correct_count]
    session[:current_question] = nil
    session[:correct_count] = nil
    session[:played_songs] = nil
  end

  # Spotifyユーザー情報の取得
  def user_info
    token = session[:spotify_token]
    begin
      response = RestClient.get("https://api.spotify.com/v1/me", {
        Authorization: "Bearer #{token}"
      })
      @user_info = JSON.parse(response.body)
      Rails.logger.info("Spotifyユーザー情報を取得しました: #{@user_info}")
      render json: @user_info
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("Spotifyユーザー情報の取得に失敗しました: #{e.response}")
      redirect_to root_path, alert: "Spotifyユーザー情報の取得に失敗しました。"
    end
  end

  private

  # Spotifyから指定ジャンルの楽曲を取得
  def get_spotify_tracks(genres)
    genre_queries = {
      'アニメ' => ERB::Util.url_encode('アニメ OR anime'),
      'ディズニー' => ERB::Util.url_encode('ディズニー OR disney'),
      '特撮' => ERB::Util.url_encode('仮面ライダー OR スーパー戦隊 OR ウルトラマン OR tokusatsu')
    }
  
    tracks = genres.flat_map do |genre|
      query = genre_queries[genre]
      next [] unless query
  
      begin
        results = RSpotify::Track.search(query, limit: 50, market: 'JP').map do |track|
          {
            name: track.name,
            artist: track.artists.first.name,
            preview_url: track.preview_url,
            album_image: track.album.images.first['url'],
            popularity: track.popularity
          }
        end
        Rails.logger.info("取得したトラックの数: #{results.size}")
        results
      rescue StandardError => e
        Rails.logger.error("エラー: #{e.message}")
        []
      end
    end
    tracks.select { |track| track[:preview_url].present? }.sort_by { |track| -track[:popularity] }
  end

  # トークンのリフレッシュ
  def refresh_spotify_token
    if session[:spotify_token_expires_at] && Time.now > session[:spotify_token_expires_at]
      begin
        response = RestClient.post("https://accounts.spotify.com/api/token", {
          grant_type: 'refresh_token',
          refresh_token: session[:spotify_refresh_token],
          client_id: ENV['SPOTIFY_CLIENT_ID'],
          client_secret: ENV['SPOTIFY_CLIENT_SECRET']
        })
  
        token_data = JSON.parse(response.body)
        session[:spotify_token] = token_data['access_token']
        session[:spotify_token_expires_at] = Time.now + token_data['expires_in'].to_i
  
        Rails.logger.info("Spotifyアクセストークンが更新されました")
  
      rescue RestClient::ExceptionWithResponse => e
        Rails.logger.error("Spotifyトークンのリフレッシュに失敗しました: #{e.response}")
        redirect_to '/auth/spotify', alert: "Spotify認証が必要です。" and return
      end
    end
  end
end
