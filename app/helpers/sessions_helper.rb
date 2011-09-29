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
    redirect_to root_path, :notice => "Доступ запрещен"
  end

  def current_user?(user)
    user == current_user
  end
  
  def authenticate
    deny_access if !signed_in?
  end

  def admin_user
    redirect_to(user_path(@current_user)) && flash[:notice] = "Доступ запрещен" unless current_user.admin?
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil,nil]
    end
end
