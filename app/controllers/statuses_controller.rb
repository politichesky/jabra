class StatusesController < ApplicationController

  def update
    @task = Task.find(params[:id])
    @task.status_id = params[:status_id]
    @task.save
    redirect_to @task
  end

  def confirm
    @task = Task.find(params[:id])
    @task.status_id = 2
    @task.save
    redirect_to @task
  end

  def done
    @task = Task.find(params[:id])
    @task.status_id = 3
    @task.save
    redirect_to @task
  end

  def abort
    @task = Task.find(params[:id])
    @task.status_id = 4
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
