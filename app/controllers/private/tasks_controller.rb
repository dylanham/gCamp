class Private::TasksController < PrivateController
  before_action :find_and_set_project
  before_action :set_task, only: [:show, :edit, :update]
  before_action :ensure_project_member_or_admin

  def index
    @tasks = @project.tasks
  end

  def show
    @comments = @task.comments.all
    @comment = @task.comments.new
  end

  def new
    @task = Task.new
  end

  def create
    task = @project.tasks.new(task_params)
    if task.save
      flash[:notice] = "Task was successfully created"
      redirect_to project_task_path(@project, task)
    else
      @task = task
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
       flash[:notice] = "Task was successfully updated"
       redirect_to project_task_path(@project, @task)
    else
      render :edit
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to project_tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:description, :complete, :due_date, :project_id)
  end

  def set_task
    @task = Task.where(project_id: @project.id).find(params[:id])
  end

  def find_and_set_project
    @project = Project.find(params[:project_id])
  end
end
