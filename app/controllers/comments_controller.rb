class CommentsController < PrivateController
  before_action :find_and_set_task, only:[:create]
  def create
    comment = Comment.new(comment_params)
    comment.user_id = current_user.id
    comment.task_id = @task.id
    if comment.save
      redirect_to project_task_path(@task.project_id, @task)
    else
      @comments = @task.comments.all
      @comment = comment
      render "tasks/show"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :user_id, :task_id)
  end

  def find_and_set_task
    @task = Task.find(params[:task_id])
  end

end
