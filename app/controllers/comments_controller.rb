class CommentsController < ApplicationController
  
  before_filter :authenticate
  
  def create
   @comment = @current_user.comments.create(params[:comment])
   if @comment.save
     flash[:success] = 'Comment added successful'
     redirect_to Task.find(params[:comment][:task_id])
    end
  end

  def destroy
  end

end
