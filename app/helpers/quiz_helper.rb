require Rails.root.join('app/services/spotify_service')
module QuizHelper
  def self.setup_new_question(genre)
    available_tracks = SpotifyService.get_spotify_tracks([genre])
    return if available_tracks.size < 4

    correct_answer = available_tracks.sample
    options = (available_tracks.reject { |track| track == correct_answer }.sample(3) << correct_answer[:name]).shuffle

    {
      correct_answer: correct_answer,
      options: options
    }
  end

  def self.reset_quiz(session)
    session[:current_question] = nil
    session[:correct_count] = nil
    session[:played_songs] = nil
    session[:correct_answer] = nil
  end

  def self.check_answer(selected_answer, correct_answer)
    selected_answer == correct_answer[:name]
  end
end
