class Private::ProjectsController < PrivateController
  before_action :set_project, except:[:index, :new, :create]
  before_action :ensure_project_member_or_admin, except: [:index, :new, :create]
  before_action :ensure_project_owner_or_admin, only:[:edit, :update, :destroy]

  def index
    @projects = current_user.projects
    @admin_projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.new(project_params)
    if project.save
      ProjectManagement.assign_current_user_as_project_owner(project, current_user)
      flash[:notice] = "Project was successfully created"
      redirect_to project_tasks_path(project)
    else
      @project = project
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
    @project.destroy
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
