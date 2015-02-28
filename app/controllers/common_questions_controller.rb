class CommonQuestionsController<ApplicationController
  skip_before_action :ensure_current_user
  def index
    answers = CommonQuestion.get_question_answer
    slugs = CommonQuestion.get_slug
    @faqs=[slugs,answers]
  end

end
