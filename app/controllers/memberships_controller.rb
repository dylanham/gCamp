class MembershipsController < ApplicationController
  before_action :find_and_set_project
  before_action :ensure_current_user


  def index
    @membership = @project.memberships.new
  end

  def create
    membership = @project.memberships.new(membership_params)
    if membership.save
      flash[:notice] = "#{membership.user.full_name} was successfully added"
      redirect_to project_memberships_path(membership.project_id)
    else
      @membership = membership
      render :index
    end
  end

  def update
    membership = Membership.find(params[:id])
    if membership.update(membership_params)
      flash[:notice] = "#{membership.user.full_name} was successfully updated"
      redirect_to project_memberships_path(membership.project_id)
    else
      @membership = membership
      render :index
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.destroy
    flash[:notice] = "#{membership.user.full_name} was successfully removed"
    redirect_to project_memberships_path(membership.project_id)
  end

  private

  def membership_params
    params.require(:membership).permit(:user_id, :project_id, :role)
  end

  def find_and_set_project
    @project = Project.find(params[:project_id])
  end

end
