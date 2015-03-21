class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def ensure_current_user
    if !current_user
      flash[:warning] = "You must sign in"
      session[:return_to] ||= request.fullpath
      redirect_to sign_in_path
    end
  end

  def current_user_should_not_see
    render file: 'public/404.html', status: :not_found, layout: false unless current_user.id == @user.id || current_user.admin
  end

  def ensure_project_member_or_admin
    if !current_user.admin_or_member?(@project)
      flash[:warning] = "You do not have access to that project"
      redirect_to projects_path
    end
  end

  def ensure_project_owner_or_admin
    if !current_user.admin_or_owner?(@project)
      flash[:warning] = "You do not have access"
      redirect_to projects_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
