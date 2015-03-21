class UsersController < ApplicationController
  before_action :set_user, only:[:show,:edit,:update]
  before_action :ensure_current_user
  before_action :current_user_should_not_see, only:[:edit, :update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User was successfully created"
      redirect_to users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated"
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    UserManagement.remove_user_id_on_comments(user)
    user.destroy
    flash[:notice] = "User was successfully deleted"
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :admin)

  end

  def set_user
    @user = User.find(params[:id])
  end

end
