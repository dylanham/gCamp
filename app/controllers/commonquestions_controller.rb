class CommonquestionsController<ApplicationController

  def index
    @questions = CommonQuestion.get_question
  end

end
