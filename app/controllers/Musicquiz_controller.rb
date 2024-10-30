class MusicquizController < ApplicationController

  def index
    @questions = MusicQuestion.all
  end

  def answer
    question_id = params[:question_id]
    answer = params[:answer]
  end
end
