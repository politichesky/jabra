#encoding: utf-8
class TasksController < ApplicationController

  before_filter :authenticate
  before_filter :author_user, :only => [:edit, :update, :destroy]
  before_filter :admin_user, :only => [:index]
  before_filter :responsible_user, :only => [:show]
 
  def index
    @tasks ||= Task.all
  end

  def sort_by_status
    status = params[:status_id]
    @tasks = status.tasks
    render :index
  end
  
  def sort_by_user
    if params[:user_id].to_i == @current_user.id
      params[:menu] ||= 'inbox'
      user = @current_user
    else
      user = User.find(params[:user_id])
    end
    @tasks = params[:status_id] ? user.incomes.find_all_by_status_id(params[:status_id]) : user.incomes
    render :index
  end

  def sort_by_author
    @tasks = params[:status_id] ? Task.find_all_by_author_id_and_status_id(params[:author_id],params[:status_id]) : Task.find_all_by_author_id(params[:author_id]) # check it!
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
    @task = @current_user.outcomes.new(params[:task])
    @task.status_id = 1
    if @task.save
      TaskMailer.new_task(@task.user,@task.author,@task).deliver if @task.user.notify_email?
      jabber_notify(@task.user.jid, "#{@task.user.name}! Пользователь #{@task.author.name} создал задачу №#{@task.id} и назначил вас ответственным. Заголовок задачи: #{@task.title}") if @task.user.notify_jabber?
      flash[:success] = "Task created"
      redirect_to task_path(@task)
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id]) # zzzzz, check it!

    if @task.update_attributes(params[:task])
      @task.status_id = 1 if @task.user_id != params[:task][:user_id] or @task.project_id != params[:task][:project_id]
      @task.save
      TaskMailer.edit(@task.user,@task.author,@task).deliver if @task.user.notify_email?
      jabber_notify(@task.user.jid, "#{@task.user.name}! Пользователь #{@task.author.name} изменил задачу №#{@task.id} и назначил вас ответственным!") if @task.user.notify_jabber?
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

end
