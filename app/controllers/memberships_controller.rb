class MembershipsController < ApplicationController
  before_action :find_and_set_project
  before_action :ensure_project_member_or_admin, only:[:index]
  before_action :ensure_project_owner_or_admin, only:[:update, :destroy]
  before_action :set_membership_and_verify_more_than_one_owner, only:[:update, :destroy]

  def index
    @membership = @project.memberships.new
  end

  def create
    membership = @project.memberships.new(membership_params)
    if membership.save
      flash[:notice] = "#{membership.user.full_name} was successfully added"
      redirect_to project_memberships_path(@project)
    else
      @membership = membership
      render :index
    end
  end

  def update
    if @membership.update(membership_params)
      flash[:notice] = "#{@membership.user.full_name} was successfully updated"
      redirect_to project_memberships_path(@project)
    else
      render :index
    end
  end

  def destroy
    @membership.destroy
    flash[:notice] = "#{@membership.user.full_name} was successfully removed"
    if current_user.id == @membership.user_id
      redirect_to projects_path
    else
      redirect_to project_memberships_path(@project)
    end
  end

  private

  def membership_params
    params.require(:membership).permit(:user_id, :project_id, :role)
  end

  def find_and_set_project
    @project = Project.find(params[:project_id])
  end

  def set_membership_and_verify_more_than_one_owner
    @membership = Membership.find(params[:id])
    if @membership.role == 'Owner' && @project.memberships.where(role: 'Owner').count <= 1
      flash[:warning] = "Projects must have at least one owner"
      redirect_to project_memberships_path(@project)
    end
  end

end
