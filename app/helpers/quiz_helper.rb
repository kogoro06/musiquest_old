require Rails.root.join('app/services/spotify_service')
module QuizHelper
  def self.setup_new_question(genre)
    available_tracks = SpotifyService.get_spotify_tracks([genre])

    # プレビューURLがある曲に限定
    available_tracks = available_tracks.select { |track| track[:preview_url].present? }

    # 十分な曲が取得できない場合はnilを返す
    return nil if available_tracks.size < 4

    correct_answer = available_tracks.sample
    remaining_tracks = available_tracks.reject { |track| track == correct_answer }
    dummy_options = remaining_tracks.sample(3).map { |track| track[:name] }

    options = (dummy_options << correct_answer[:name]).shuffle

    {
      correct_answer: correct_answer,
      options: options
    }
  end

  def self.check_answer(selected_answer, correct_answer)
    Rails.logger.debug("check_answer - 選択された答え: #{selected_answer}")
    Rails.logger.debug("check_answer - 正解の答え全体: #{correct_answer.inspect}")
    
    # correct_answerがnilの場合に備えて安全な操作を行う
    if correct_answer.nil? || correct_answer[:name].nil?
      Rails.logger.error("check_answer - 正解の答えがnilです。正しいデータを確認してください。")
      return false
    end

    selected_answer == correct_answer[:name]
  end
end