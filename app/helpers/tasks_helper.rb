module TasksHelper

  def task_author_name(task)
    task.author.name rescue "anonymous"
  end

  def colorize(item)
    item.status.title rescue "new"
  end


end
