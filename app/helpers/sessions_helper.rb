#encoding: utf-8

module SessionsHelper
  def login(user)
    cookies.permanent.signed[:remember_token] = [user.id,user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end
  
  def admin?
    @current_user.admin
  end

  def logout
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def deny_access
    if @current_user 
      redirect_to user_path(@current_user), :notice => "Доступ запрещен" 
    else
      redirect_to root_path, :notice => "Доступ запрещен"
    end
  end

  def current_user?(user)
    user == current_user
  end
  
  def authenticate
    deny_access if !signed_in?
  end

  def admin_user
    deny_access unless @current_user && admin?
  end
  
  def author_user
    @task = Task.find(params[:id])
    deny_access unless @task.author == @current_user or admin?
  end

  def responsible_user
    @task = Task.find(params[:id])
    deny_access unless @current_user == @task.user or @current_user == @task.author or admin?
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil,nil]
    end
end
