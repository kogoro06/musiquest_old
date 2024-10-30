class MusicquizController < ApplicationController

  def index
    @questions = MusicQuestion.all
  end

  def answer
    question_id = params[:question_id]
    answer = params[:answer]
  end

  def genre
    # このメソッドに必要な処理を追加
  end

  def era
    # 必要な処理を追加
  end
  def ranking
    # Spotify APIからTop 50とViral 50のデータを取得
    @top_tracks = SpotifyService.get_top_tracks
    @viral_tracks = SpotifyService.get_viral_tracks
  end
  def play_from_playlist
    playlist_id = params[:playlist_id]
    @tracks = SpotifyService.get_tracks_from_playlist(playlist_id) # プレイリストから楽曲を取得
  
    # あなたのロジックに従って問題を出題する処理を追加します
  end
  def correct_tracks
    @correct_tracks = session[:correct_tracks] || [] # セッションから正解した曲のリストを取得
  end

  def ranking
    # ここでは、ランキングのデータを取得するロジックを追加します
    @rankings = [] # ここにランキングデータを設定
  end

  def online_mode
    # オンライン対戦モードのロジックを追加
  end
end