#encoding: utf-8
class TaskMailer < ActionMailer::Base
  default :from => "rasherny@gmail.com"

  # responsible user notify

  def new_task(user,author,task)
    @user,@author,@task = user,author,task
    mail(:to => @user.email, :subject => "Новая задача на багтрекере")
  end
  def edit(user,author,task)
    @user,@author,@task = user,author,task
    mail(:to => @user.email, :subject => "Задача № #{@task.id} была изменена автором")
  end

  # author notify

  def confirm (user,author,task)
    @user,@author,@task = user,author,task
    mail(:to => @author.email, :subject => "Задача № #{@task.id} подтверждена пользователем #{@user.name}")
  end
  def done (user,author,task)
    @user,@author,@task = user,author,task
    mail(:to => @author.email, :subject => "Задача № #{@task.id} выполнена пользователем #{@user.name}")
  end
  def abort (user,author,task)
    @user,@author,@task = user,author,task
    mail(:to => @author.email, :subject => "Задача № #{@task.id} отклонена пользователем #{@user.name}")
  end

  # comment notify
  def new_comment (user,comment)
    @user,@comment = user,comment
    mail(:to => @user.email, :subject => "Новый комментарий к задаче № #{comment.task.id}")
  end

end
