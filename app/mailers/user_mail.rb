class UserMail < ActionMailer::Base
  default :from => "rasherny@gmail.com"

  def welcome(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to bugtracker")
  end
end
