require 'rest-client'
require 'json'

class MusicquizController < ApplicationController
  before_action :refresh_spotify_token, only: [:play, :start, :user_info]

  # Spotify認証後のコールバック
  def callback
    token_data = SpotifyService.get_access_token(params[:code])
    session[:spotify_token] = token_data[:access_token]
    session[:spotify_refresh_token] = token_data[:refresh_token]
    session[:spotify_token_expires_at] = Time.now + token_data[:expires_in].to_i
    redirect_to musicquiz_start_path, notice: "Spotify認証に成功しました！"
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
    # 初回プレイ時のセッション設定
    if session[:current_question].nil?
      QuizHelper.reset_quiz(session)
      session[:current_question] = 1
    end

    # current_questionが10より大きい場合は結果ページへリダイレクト
    redirect_to final_results_path if session[:current_question] > 10

    # クイズの問題設定
    question = QuizHelper.setup_new_question(session[:genre])
    if question
      @correct_answer, @options = question[:correct_answer], question[:options]
    else
      flash.now[:alert] = "十分な数の曲を取得できませんでした。再試行してください。"
      render :play and return
    end
  end

  def show_result
    correct_answer = session[:correct_answer]
    @selected_answer = params[:selected_answer]
    @is_correct = QuizHelper.check_answer(@selected_answer, correct_answer)

    session[:correct_count] += 1 if @is_correct
    session[:current_question] += 1
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
