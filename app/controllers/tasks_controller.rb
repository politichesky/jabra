#TODO: reduce the amount of code in the controller!

=begin
  This params set for each action in controller. If you're requesting сontroller for the first time, set target and target_id manually, or get an error
  target:
    "user" for user.incomes
    "author" for user.outcomes
    "project" for project.tasks
  target_id: 
    id
  type:
    0 - all
    1 - bugs
    2 - features
    3 - requests
  status:
    0 - all
    1 - new
    2 - accepted
    3 - done
    4 - aborted
=end

class TasksController < ApplicationController
  before_filter :check_admin_access, :only => :destroy
  before_filter :check_developer_access, :only => [:edit,:update]
  before_filter :set_params # set tasks target,target_id,type and status, see method
  before_filter :select_filter # start checking the permission to see a user or project
  before_filter :get_items, :only => :index # get tasks for requested params
  before_filter :init_sidebar # set target for sidebar
  
  def default_url_options
    { :target => @target, :target_id => @target_id, :status => @status, :type => @type } # set params for next action
  end

  def new
    @task = Task.new
    render "_form"
  end

  def create
    @task = current_user.outcomes.new(params[:task])
    if @task.save
      #TODO: Review the mechanism of processing status in all actions!
      @task.auto_accept if @task.type_id == 3 # if task type is the feature - automatically confirm task by author
      flash[:success] = "Task successful created"
      redirect_to tasks_path
    else
      render '_form'
    end
  end

  def index
    @comment = Comment.new
    render "shared/_index"
  end

  def show
    @item = Task.find params[:id]
    @comment = Comment.new
    render 'shared/_show'
  end

  def edit
    @task = Task.find(params[:id])
    render '_form'
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      current_user.incomes << @task if params[:task][:status_id]
      flash[:success] = "Task successful updated!"
      redirect_to tasks_path
    else
      render '_form'
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:success] = "Task successful destroy"
    rescue
      flash[:error] = "Task does not destroy! Error!"
    ensure
      redirect_to tasks_path
  end

  private

  def set_params
    begin
      @target = params[:target]
      @target_id = params[:target_id]
      if @target_id.empty?
        case @target 
          when "project" then redirect_to projects_path if @target_id.empty?
          when "user" then redirect_to users_path if @target_id.empty?
        end
      end
    rescue
      flash[:error] = "Bad url!"
      redirect_to root_path
    end
    @status = params[:status] rescue 0
    @type = params[:type] rescue 0
  end

  def get_items
    case @target
      when "user"
        @current_target = User.find(@target_id)
        @items = @current_target.incomes # find all tasks accepted by user
      when "project"
        @current_target = Project.find(@target_id)
        @items = @current_target.tasks
      when "author"
        @items = User.find(@target_id).outcomes # find all tasks created by user
      else
        @items = []
        flash[:error] = "Can't show request tasks, error. Have you created your request manually? :)"
    end
    @items = Task.set_type @items,@type
    @items = Task.set_status @items,@status
  end
end
