class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update]
  before_action :ensure_current_user
  before_action :find_and_set_project

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
      redirect_to project_task_path(task.project_id, task)
    else
      @task = task
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @project.tasks.update(@task.id, task_params)
       flash[:notice] = "Task was successfully updated"
       redirect_to project_task_path(@task.project_id, @task)
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
    @task = Task.find(params[:id])
  end

  def find_and_set_project
    @project = Project.find(params[:project_id])
  end

end
