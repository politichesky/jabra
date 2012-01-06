class ProjectsController < ApplicationController
  before_filter :check_admin_access, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :check_access_to_project, :only => :show
  before_filter :set_params, :only => [:show, :edit]
  before_filter :init_sidebar, :only => [:show, :edit]
  
  def default_url_options
    {:target => @target, :target_id => @target_id, :status => @status, :type => @type} # set params for next action
  end

  def new
    @project = Project.new
    render '_form'
  end

  def create
    @project = Project.new params[:project]
    if @project.save
      @project.create_relations params[:users] unless params[:project][:public].to_i == 1
      @project.create_avatar(params[:project_image]) if params[:project_image]
      flash[:success] = "Project successful created"
      redirect_to projects_path
    else
      render '_form'
    end
  end

  def index
    @items = Project.get_projects_for current_user
    render "shared/_index"
  end

  def show
    @item = Project.find params[:id]
    render "shared/_show"
  end

  def edit
    @project = Project.find params[:id] 
    render '_form'
  end

  def update
    @project = Project.find params[:id]
    if @project.update_attributes params[:project]
      @project.update_relations params[:project][:public], params[:users]
      @project.create_avatar(params[:project_image]) if params[:project_image]
      flash[:success] = "Project successful updated!"
      redirect_to projects_path
    else
      render '_form'
    end
  end

  def destroy
    Project.find(params[:id]).destroy
    flash[:success] = "Project successful destroy"
    rescue
      flash[:error] = "Project does not destroy! Error!"
    ensure
      redirect_to projects_path
  end

  private

  def set_params
    begin
      @target = "project"
      @target_id = params[:id]
    rescue
      flash[:error] = "Bad url!"
      redirect_to root_path
    end
    @status = params[:status] rescue 0
    @type = params[:type] rescue 0
  end
end
