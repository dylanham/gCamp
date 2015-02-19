class ProjectsController < ApplicationController
  before_action :set_project, only:[:show, :edit, :update]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:notice] = "Project was successfully created"
      redirect_to @project
    else
      render :new
    end
  end


  def edit
  end

  def update
    if @project.update(project_params)
      flash[:notice] = "Project was successfully updated"
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    flash[:notice] = "Project was successfully deleted"
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def set_project
    @project = Project.find(params[:id])
  end
  
end
