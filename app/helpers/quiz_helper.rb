require Rails.root.join('app/services/spotify_service')
module QuizHelper
  def self.setup_new_question(genre)
    available_tracks = SpotifyService.get_spotify_tracks([genre])

    if available_tracks.empty?
      Rails.logger.error("get_spotify_tracksが空の結果を返しました - ジャンル: #{genre}")
      return nil
    end

    correct_answer = available_tracks.sample
    options = (available_tracks.reject { |track| track == correct_answer }.sample(3) << correct_answer[:name]).shuffle

    {
      correct_answer: correct_answer,
      options: options
    }
  end
end
