class SessionsController < ApplicationController

  skip_before_filter :authenticate

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "Примите поздравления! Вы успешно вошли в систему!"
      redirect_to root_path
    else
      flash[:error] = "Неправильная пара email/пароль"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
      flash[:success] = "Вы успешно вышли из системы. Возвращайтесь!"
    redirect_to login_path
  end

  def new
    redirect_to root_path if session[:user_id]
  end
end
