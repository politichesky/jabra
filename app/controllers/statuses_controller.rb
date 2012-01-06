class StatusesController < ApplicationController
  def default_url_options
    {:target => session[:target], :target_id => session[:target_id], :status => 0, :type => 0} #set params for each action
  end

  def update
    status = params[:status_id]
    task = Task.find params[:id]
    user = current_user
    case status.to_i
      when 2
        task.accept(user)
      when 3
        task.done
      when 4
        task.abort
    end
    flash[:success] = "Task successful changed!"
    redirect_to tasks_path
  end


end
