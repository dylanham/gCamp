class Private::TasksController < PrivateController
  before_action :set_task, only: [:show, :edit, :update]
  before_action :find_and_set_project
  before_action :ensure_project_member_or_admin
  before_action :ensure_task_belongs_to_project, only:[:show]

  def index
    @tasks = @project.tasks
  end

  def new
    @task = @project.tasks.new
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

  def show
    @comments = @task.comments.all
    @comment = @task.comments.new
  end

  def edit
  end

  def update
    task = @project.tasks.find(params[:id])
    if task.update(task_params)
       flash[:notice] = "Task was successfully updated"
       redirect_to project_task_path(@project, task)
    else
      @task = task
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
    @task = Task.find(params[:id])
  end

  def find_and_set_project
    @project = Project.find(params[:project_id])
  end

  def ensure_task_belongs_to_project
    if !@project.tasks.include?(@task)
      flash[:warning] = 'You do not have access to that project'
      redirect_to projects_path
    end
  end

end