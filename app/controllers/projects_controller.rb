class ProjectsController < ApplicationController

before_filter :authenticate
before_filter :admin_user, :only => [:new, :create, :destroy, :edit, :update] 

def index
  @projects = Project.all
end

def new
  @project = Project.new
end

def show
  @project = Project.find(params[:id])
end

def edit
  @project = Project.find(params[:id])
end

def create
  @project = Project.new(params[:project])
  if @project.save
    flash[:success] = "Project created"
    redirect_to projects_path
  else
    render :new
  end
end
  
def update
  @project = Project.find(params[:id])
  if @project.update_attributes(params[:project])
    flash[:success] = "Project updated"
    redirect_to @project
  else
    render 'edit'
  end
end

def destroy
   Project.find(params[:id]).destroy
   flash[:success] = "Project destroyed"
   redirect_to projects_path
end

end
