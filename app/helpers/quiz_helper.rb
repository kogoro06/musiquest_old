require Rails.root.join('app/services/spotify_service')
module QuizHelper
  def self.setup_new_question(genre)
    available_tracks = SpotifyService.get_spotify_tracks([genre])

    # 十分な曲が取得できない場合はnilを返す
    return nil if available_tracks.size < 4

    # 正解の曲をランダムに選択
    correct_answer = available_tracks.sample

    # 正解の曲を除いたリストから3つのダミー選択肢を選ぶ
    remaining_tracks = available_tracks.reject { |track| track == correct_answer }
    dummy_options = remaining_tracks.sample(3).map { |track| track[:name] }

    # 正解の曲名を追加し、選択肢をシャッフル
    options = (dummy_options << correct_answer[:name]).shuffle

    {
      correct_answer: correct_answer,
      options: options
    }
  end
end
