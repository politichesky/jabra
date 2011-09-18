module TasksHelper
  def author?
    @task.author_id == @current_user.id
  end

  def responsible_user?
    @task.user_id == @current_user.id
  end
end
