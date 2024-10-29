require 'rest-client'
require 'json'

class MusicquizController < ApplicationController
  before_action :refresh_spotify_token, only: [:play, :start]

  # Spotify認証後のコールバック
  def callback
    token_data = SpotifyService.get_access_token(params[:code])
    if token_data
      session[:spotify_token] = token_data[:access_token]
      session[:spotify_refresh_token] = token_data[:refresh_token]
      session[:spotify_token_expires_at] = Time.now + token_data[:expires_in].to_i
      Rails.logger.debug("Spotify認証成功 - トークン: #{session[:spotify_token]}, リフレッシュトークン: #{session[:spotify_refresh_token]}")
      redirect_to musicquiz_start_path, notice: "Spotify認証に成功しました！"
    else
      Rails.logger.error("Spotify認証失敗 - トークンが取得できませんでした")
      redirect_to root_path, alert: "Spotify認証に失敗しました。"
    end
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error("トークンの取得に失敗しました: #{e.response}")
    redirect_to root_path, alert: "Spotify認証に失敗しました。"
  end
  def setup_new_question
    question = QuizHelper.setup_new_question(session[:genre])
    if question.nil?
      render json: { error: '十分な数の曲を取得できませんでした。' }, status: :unprocessable_entity
    else
      render json: question
    end
  end

  def play
    session[:genre] ||= 'アニメ'
    if session[:current_question].nil?
      QuizHelper.reset_quiz(session)
      session[:current_question] = 1
    end

    redirect_to final_results_path if session[:current_question] > 10

    # クイズの設定取得
    question = QuizHelper.setup_new_question(session[:genre])
    if question
      @correct_answer = question[:correct_answer]
      @options = question[:options]
      
      # デバッグ用のログ出力
      Rails.logger.debug("クイズ設定 - 正解の曲名: #{@correct_answer[:name]}")
      Rails.logger.debug("クイズ設定 - プレビューURL: #{@correct_answer[:preview_url]}")
      Rails.logger.debug("クイズ設定 - 選択肢: #{@options}")
    else
      Rails.logger.error("setup_new_questionがnilを返しました - トラックが取得できなかった可能性があります")
      flash.now[:alert] = "十分な数の曲を取得できませんでした。再試行してください。"
      render :play and return
    end
  end
  class MusicquizController < ApplicationController
    def show_result
      correct_answer = session[:correct_answer]
      if correct_answer.nil?
        redirect_to musicquiz_start_path, alert: "正解データが見つかりませんでした。再度プレイしてください。"
        return
      end
  
      @selected_answer = params[:selected_answer]
      @is_correct = QuizHelper.check_answer(@selected_answer, correct_answer)
  
      # 正解情報をインスタンス変数に設定
      @correct_answer_name = correct_answer[:name]
      @correct_answer_artist = correct_answer[:artist]
      @correct_answer_album_image = correct_answer[:album_image]
      @correct_answer_preview_url = correct_answer[:preview_url]
  
      # 正解数と問題数を更新
      session[:correct_count] ||= 0
      session[:correct_count] += 1 if @is_correct
      session[:current_question] ||= 1
      session[:current_question] += 1
    end
  end
  
  def final_results
    @correct_count = session[:correct_count]
    QuizHelper.reset_quiz(session) # 引数を追加
  end

  def user_info
    @user_info = SpotifyService.get_user_info(session[:spotify_token]) # SpotifyServiceを使用
    render json: @user_info
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error("Spotifyユーザー情報の取得に失敗しました: #{e.response}")
    redirect_to root_path, alert: "Spotifyユーザー情報の取得に失敗しました。"
  end

  private

  def refresh_spotify_token
    if session[:spotify_token_expires_at] && Time.now > session[:spotify_token_expires_at]
      token_data = SpotifyService.refresh_access_token(session[:spotify_refresh_token]) # SpotifyServiceを使用
      session[:spotify_token] = token_data[:access_token]
      session[:spotify_token_expires_at] = Time.now + token_data[:expires_in].to_i
    end
  end
end