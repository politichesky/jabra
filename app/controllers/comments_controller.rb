class CommentsController < ApplicationController
  
  def create
    @comment = current_user.comments.new params[:comment]
    if @comment.save
      flash[:success] = "Comment successful added"
    else
      flash[:error] = "Error! Comment not added"
    end
    redirect_to task_path @comment.task, :target => "project", :target_id => @comment.task.project.id
  end

  def destroy
    @comment = Comment.find params[:id]
    if @comment.destroy
      flash[:success] = "Comment successful destroyed"
    else
      flash[:error] = "Error! Comment not destroyed"
    end
    redirect_to task_path @comment.task, :target => "project", :target_id => @comment.task.project.id

  end

end
