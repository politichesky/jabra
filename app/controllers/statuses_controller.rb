#encoding: utf-8
class StatusesController < ApplicationController
  before_filter :authenticate
  before_filter :responsible_user, :only => [:update]

  def update
    @task = Task.find(params[:id])
    @task.status_id = params[:status_id]
    @task.save
    
    case params[:status_id].to_i
    when 2
      TaskMailer.confirm(@task.user,@task.author,@task).deliver if @task.author.notify_email?
      jabber_notify(@task.author.jid, "#{@task.author.name}! Ваша заявка №#{@task.id} принята в рассмотрение участником #{@task.user.name}!") if @task.author.notify_jabber?
    when 3
      TaskMailer.done(@task.user,@task.author,@task).deliver if @task.author.notify_email?
      jabber_notify(@task.author.jid, "#{@task.author.name}! Ваша заявка №#{@task.id} выполнена участником #{@task.user.name}") if @task.author.notify_jabber?
    when 4
      TaskMailer.abort(@task.user,@task.author,@task).deliver if @task.author.notify_email?
      jabber_notify(@task.author.jid, "#{@task.author.name}! Ваша заявка №#{@task.id} отклонена участником #{@task.user.name}") if @task.author.notify_jabber?
    end

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
