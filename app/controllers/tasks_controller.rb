class TasksController < ApplicationController

  before_filter :authenticate
  before_filter :author_user, :only => [:edit, :update, :destroy] 
 
  def index
    @tasks ||= Task.all
  end

  def sort_by_status
    @tasks = Task.find_all_by_status_id(params[:status_id])
    render :index
  end
  
  def sort_by_user
#   user = params[:user_id] == @current_user.id ? @current_user : User.find(params[:user_id]) 
    if params[:user_id].to_i == @current_user.id
      params[:menu] ||= 'inbox'
      user = @current_user
    else
      user = User.find(params[:user_id])
    end
    @tasks = params[:status_id] ? user.tasks.find_all_by_status_id(params[:status_id]) : user.tasks
    render :index
  end

  def sort_by_author
    @tasks = params[:status_id] ? Task.find_all_by_author_id_and_status_id(params[:author_id],params[:status_id]) : Task.find_all_by_author_id(params[:author_id]) 
    params[:menu] ||= 'outbox' if params[:author_id].to_i == @current_user.id
    render :index
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end
  
  def create
    @task = Task.new(params[:task])
    @task.status_id = 1
    @task.author_id = @current_user.id
    if @task.save
      flash[:success] = "Task created"
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(params[:task])
      @task.status_id = 1 if @task.user_id != params[:task][:user_id] or @task.project_id != params[:task][:project_id]
      @task.save
      flash[:success] = "Task updated"
      redirect_to @task
    else
      render 'edit'
    end
  end

  def show
    @task = Task.find(params[:id])
    @comment = Comment.new
  end
  
  def destroy
     Task.find(params[:id]).destroy
     flash[:success] = "Task destroyed"
     redirect_to tasks_path
  end

  private

    def author_user
      @task = Task.find(params[:id])
      deny_access if @task.author_id != current_user.id
    end
    
end
