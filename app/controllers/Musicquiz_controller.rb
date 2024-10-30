class MusicquizController < ApplicationController
  include SpotifyTokenManager

  def index
    @questions = MusicQuestion.all
  end

  def answer
    question_id = params[:question_id]
    answer = params[:answer]
  end

  def genre
    # ジャンルに応じた処理を実装
  end

  def era
    # 年代に応じた処理を実装
  end

  def ranking
    @top_tracks = SpotifyService.get_top_tracks
    @viral_tracks = SpotifyService.get_viral_tracks
  end

  def play_from_playlist
    playlist_id = params[:playlist_id]
    @tracks = SpotifyService.get_tracks_from_playlist(playlist_id)
  end

  def correct_tracks
    @correct_tracks = session[:correct_tracks] || []
  end

  def user_ranking
    @user_rankings = [] # ユーザーのランキングデータを設定
  end

  def online_mode
    # オンライン対戦モードのロジックを追加
  end
end
