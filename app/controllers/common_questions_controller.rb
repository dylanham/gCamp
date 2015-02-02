class CommonQuestionsController<ApplicationController

  def index
    @questions = CommonQuestion.get_question
    @answers = CommonQuestion.get_answer
    @slugs = CommonQuestion.get_slug
    @array=[@answers,@slugs]
  end

end
