class GenreController < ApplicationController
  include SpotifyTokenManager

  # トークンリフレッシュを必要とするアクションを指定
  before_action :refresh_spotify_token, only: [:play_jpop, :play_kpop, :play_westernmusic, :play_anime, :play_hiphop]

  def play_jpop
    handle_play_genre('jpop')
  end

  def play_kpop
    handle_play_genre('kpop')
  end

  def play_westernmusic
    handle_play_genre('westernmusic')
  end

  def play_anime
    handle_play_genre('anime')
  end

  def play_hiphop
    handle_play_genre('hiphop')
  end

  private

  def handle_play_genre(genre)
    # Spotifyのトラックを取得
    available_tracks = SpotifyService.get_spotify_tracks([genre])

    if available_tracks.nil? || available_tracks.empty?
      flash[:alert] = "#{genre.capitalize}のトラックが見つかりませんでした。"
      redirect_to musicquiz_genre_path and return
    end

    # プレビューURLがある曲に限定
    available_tracks.select! { |track| track[:preview_url].present? }

    if available_tracks.size < 4
      flash[:alert] = "十分な曲が取得できませんでした。"
      redirect_to musicquiz_genre_path and return
    end

    # クイズのためのロジックを実装
    session[:current_question] ||= 1
    question = QuizHelper.setup_new_question(available_tracks)

    if question
      session[:correct_answer] = question[:correct_answer]  # 正解データをセッションに保存
      @correct_answer = session[:correct_answer]
      @options = question[:options]
    else
      flash.now[:alert] = "十分な数の曲を取得できませんでした。再試行してください。"
      render "play_#{genre}" and return  # 対応するビューを表示
    end

    render "play_#{genre}"  # 対応するビューを表示
  end
end
