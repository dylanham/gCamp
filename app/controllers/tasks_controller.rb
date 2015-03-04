class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update]
  before_action :ensure_current_user
  
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "Task was successfully created"
      redirect_to @task
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
       flash[:notice] = "Task was successfully updated"
       redirect_to @task
    else
      render :edit
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:description, :complete, :due_date)
  end

  def set_task
    @task = Task.find(params[:id])
  end

end
