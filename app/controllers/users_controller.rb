class UsersController < ApplicationController
  skip_before_filter :authenticate, :only => [:new, :create]
  before_filter :check_current_user, :only => [:show,:edit,:update]
  before_filter :check_admin_access, :only => [:index, :destroy]
  before_filter :set_params, :only => [:show, :edit]
  before_filter :init_sidebar, :only => [:show, :edit]

  def default_url_options
    {:target => @target, :target_id => @target_id, :status => @status, :type => @type} # set params for next action
  end

  def new
    @user = User.new
    @contact = Contact.new
    render "_form"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.create_contact(params[:contact])
      @user.create_avatar(params[:user_image]) if params[:user_image]
      unless current_user
        @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        flash[:success] = "Congratulations! You have successfully registered!"
        redirect_to root_path
      else
        flash[:success] = "User successful created"
        redirect_to @user
      end
    else
      @contact = Contact.new #TODO: shit, refactoring
      render '_form'
    end
  end

  def show
    @item = User.find params[:id]
    render 'shared/_show'
  end

  def index
    @items = User.all
    render "shared/_index"
  end

  def edit
    @user = User.find(params[:id])
    @contact = @user.contact
    render '_form'
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      @user.update_contact(params[:contact])
      @user.create_avatar(params[:user_image]) if params[:user_image]
      flash[:success] = "User successful updated!"
      redirect_to @user
    else
      render '_form'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User successful destroy"
    rescue
      flash[:error] = "User does not destroy! Error!"
    ensure
      redirect_to users_path
  end
  
  private

  def set_params
    begin
      @target = "user"
      @target_id = params[:id]
    rescue
      flash[:error] = "Bad url!"
      redirect_to root_path
    end
    @status = params[:status] rescue 0
    @type = params[:type] rescue 0
  end
end
