class StatusesController < ApplicationController
  before_filter :authenticate
  before_filter :responsible_user, :only => [:update]

  def update
    @task = Task.find(params[:id])
    @task.status_id = params[:status_id]
    @task.save
    redirect_to @task
  end
# not used now

  def closed
    @task = Task.find(params[:id])
    @task.closed = true
    @task.save
    redirect_to @task
  end

end
