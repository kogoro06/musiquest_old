class MusicquizController < ApplicationController
  before_action :refresh_spotify_token, only: [:play, :start]

  # playアクション
def play
  session[:current_question] ||= 1
  session[:genre] ||= 'アニメ'
  question = QuizHelper.setup_new_question(session[:genre])

  if question
    session[:correct_answer] = question[:correct_answer] # 正解データをセッションに保存
    @correct_answer = session[:correct_answer] # @correct_answerに正解データを設定
    @options = question[:options]

    # デバッグログで確認
    Rails.logger.debug("play - セッションに保存する正解データ: #{session[:correct_answer].inspect}")
    Rails.logger.debug("play - 現在の問題番号: #{session[:current_question]}")
  else
    flash.now[:alert] = "十分な数の曲を取得できませんでした。再試行してください。"
    render :play and return
  end
end


  # show_resultアクション
  def show_result
    # セッションから正確なデータを取得
    @correct_answer = session[:correct_answer]
    Rails.logger.debug("show_result - セッションからの正解データ: #{@correct_answer.inspect}")
  
    if @correct_answer.nil?
      Rails.logger.error("show_result - 正解データが見つかりませんでした。セッションがリセットされている可能性があります。")
      redirect_to musicquiz_start_path, alert: "正解データが見つかりませんでした。再度プレイしてください。"
      return
    end
  
    # 選択された答えを取得
    @selected_answer = params[:selected_answer]
    Rails.logger.debug("show_result - 選択された答え: #{@selected_answer}")
  
    # check_answerにデータを正確に渡す
    @is_correct = QuizHelper.check_answer(@selected_answer, @correct_answer)
    Rails.logger.debug("check_answer - 正解判定結果: #{@is_correct}")
  
    # 正解データの表示用設定
    @correct_answer_name = @correct_answer[:name]
    @correct_answer_artist = @correct_answer[:artist]
    @correct_answer_album_image = @correct_answer[:album_image]
    @correct_answer_preview_url = @correct_answer[:preview_url]
  
    # 正解数と問題数を更新
    session[:correct_count] ||= 0
    session[:correct_count] += 1 if @is_correct
    session[:current_question] += 1
    Rails.logger.debug("show_result - 更新後の問題番号: #{session[:current_question]}")
  end

  private

  def refresh_spotify_token
    if session[:spotify_token_expires_at] && Time.now > session[:spotify_token_expires_at]
      token_data = SpotifyService.refresh_access_token(session[:spotify_refresh_token])
      if token_data
        session[:spotify_token] = token_data[:access_token]
        session[:spotify_token_expires_at] = Time.now + token_data[:expires_in].to_i
      else
        redirect_to '/auth/spotify', alert: "Spotify認証が必要です。" and return
      end
    end
  end
end
