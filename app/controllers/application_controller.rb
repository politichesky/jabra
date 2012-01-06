class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate

  def current_user
    @current_user ||= session[:user_id] ? User.find(session[:user_id]) : false
  end

  helper_method :current_user

  private
  
  def init_sidebar
    case @target
      when "user","author" then @current_target = User.find(@target_id)
      when "project" then @current_target = Project.find(@target_id)
    end
  end
  
  # FILTERS
  
  # select filter for tasks#index
  def select_filter
    case @target
      when "user","author" then check_current_user
      when "project" then check_access_to_project
    end
  end

  def check_access_to_project
    case controller_name
      when "projects" then id = params[:id]
      when "tasks" then id = params[:target_id]
    end
    current_project = Project.find(id)
    access_denied unless ( current_user.projects.include?(current_project) or current_project.public? or current_user.admin?) 
  end
  
  def check_current_user
    case controller_name
      when "users" then id = params[:id]
      when "tasks" then id = params[:target_id]
    end
    access_denied unless current_user.id == id.to_i or current_user.admin?
  end

  def check_admin_access
    access_denied unless current_user.admin?
  end

  def check_developer_access
    access_denied unless current_user.developer?
  end

  def authenticate
    access_denied unless current_user
  end

  def access_denied
    flash[:error] = "Access denied"
    redirect_to root_path
  end
  
end
