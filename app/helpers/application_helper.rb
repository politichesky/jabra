module ApplicationHelper

  def new_tasks_for_user
    tasks = current_user.projects.each{ |p| p.tasks.new_task }
    tasks.count 
    rescue 
      0
  end

  def user_tasks
    current_user.outcomes.count 
    rescue 
      0
  end

  def user_status(user)
    user.access.title rescue "none"
  end

  def avatar_image(obj,size)
    obj.image.img.url(size) rescue "avatar.png"
  end


end
