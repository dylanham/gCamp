class CommonQuestionsController<ApplicationController

  def index
    answers = CommonQuestion.get_answer
    slugs = CommonQuestion.get_slug
    @faqs=[slugs,answers]
  end

end
