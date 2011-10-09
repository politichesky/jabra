#encoding: utf-8
require 'spec_helper'

describe TasksController do
  render_views

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should redirect to root and show an error message" do
        get :new
        response.should redirect_to(root_path)
        flash[:notice].should =~ /доступ запрещен/i
      end
    end
    describe "for sign-in users" do
      it "should show form for create new task" do
        @user = Factory.create(:user)
        test_sign_in(@user)
        get :new
        response.should be_success
      end
    end
  end
  describe "GET 'index'" do
    before(:each) do
      @user = Factory.create(:user)
      @project = Factory.create(:project)
      @status = Factory.create(:status)
      @task = @user.outcomes.create!(Factory.attributes_for(:task, :user_id => @user.id, :project_id => @project.id, :status_id => @status.id))
    end
    describe "for non-signed users" do
      it "should redirect to root and show an error message" do
        get :index
        response.should redirect_to(root_path)
        flash[:notice].should =~ /доступ запрещен/i
      end
    end
    describe "for non-admin users" do
      it "should redirect to user's profile and show an error message" do
        test_sign_in(@user)
        get :index
        response.should redirect_to(user_path(@user))
        flash[:notice].should =~ /доступ запрещен/i
      end
    end
    describe "for admin users" do
      it "should show all tasks" do
        test_sign_in(@user)
        @user.admin = true
        get :index
        response.should be_success
      end
    end
  end
  describe "GET 'show'" do
    before(:each) do
      @user = Factory.create(:user)
      @author = Factory.create(:user,:email => Factory.next(:email))
      @project = Factory.create(:project)
      @status = Factory.create(:status)
      @task = @author.outcomes.create!(Factory.attributes_for(:task, :user_id => @user.id, :status_id => @status.id, :project_id => @project.id))
    end
    describe "for non-signed user" do
      it "should redirect to root and show an error message" do
        get :show, :id => @task.id
        response.should redirect_to(root_path)
        flash[:notice].should =~ /доступ запрещен/i
      end
    end
    describe "for signed-in user" do
      describe "if user is task's author" do
        it "should show task info" do
          test_sign_in(@author)
          get :show, :id => @task.id
          response.should be_success
        end
      end
      describe "if user is a responsible user" do
        it "should show task info" do
          test_sign_in(@user)
          get :show, :id => @task.id
          response.should be_success
        end
      end
      describe "if user is an admin user" do
        it "should show task info" do
          admin = Factory.create(:admin)
          test_sign_in(admin)
          get :show, :id => @task.id
          response.should be_success
        end
      end
      describe "if user is not an task's author or a responsible user" do
        it "should redirect to user's profile and show an error message" do
          @bad_user = Factory.create(:user, :email => Factory.next(:email))
          test_sign_in(@bad_user)
          get :show, :id => @task.id
          response.should redirect_to(user_path(@bad_user))
          flash[:notice].should =~ /доступ запрещен/i
        end
      end
    end
  end
  describe "POST 'create'" do
    describe "for non-signed users" do
      it "should redirect to root and show an error message" do
        @attr = Factory.attributes_for(:task,:status_id =>1,:author_id=>1,:user_id=>1,:project_id=>1)
        post :create, :task => @attr
        response.should redirect_to(root_path)
        flash[:notice].should =~ /доступ запрещен/i
      end
    end
    describe "for signed-in users" do
      before(:each) do
        @author = Factory.create(:user)
        @user = Factory.create(:user, :email => Factory.next(:email))
        @project = Factory.create(:project)
        @status = Factory.create(:status)
        @attr = Factory.attributes_for(:task, :user_id => @user.id, :project_id => @project.id, :status_id => @status.id)
      end
      it "should create a new task" do
        test_sign_in(@author)
        lambda do 
          post :create, :task => @attr
        end.should change(Task,:count)
      end
    end
  end
  describe "PUT 'update'" do
    before(:each) do
      @user = Factory.create(:user)
      @project = Factory.create(:project)
      @status = Factory.create(:status)
      @attr = Factory.attributes_for(:task, :user_id => @user.id, :project_id => @project.id, :status_id => @status.id)
      @task = @user.outcomes.create!(@attr)
    end
    describe "for non-signed users" do
      it "should redirect to root and show an error message" do
        put :update, :id => @task, :task => @attr
        response.should redirect_to(root_path)
        flash[:notice].should =~ /доступ запрещен/i
      end
      it "should do not change task's attributes" do
        put :update, :id => @task, :task => @attr.merge(:content => 'another content')
        @task.reload
        @task.content.should_not == 'another content'
      end
    end
    describe "for sign-in users" do
      describe "for not author users" do
        before(:each) do
          @bad_user = Factory.create(:user,:email => Factory.next(:email))
          test_sign_in(@bad_user)
        end
        it "should redirect to user's profile and show an error message" do
          put :update, :id => @task, :task => @attr
          response.should redirect_to(user_path(@bad_user))
          flash[:notice].should =~ /доступ запрещен/i
        end
        it "should do not change task's attributes" do
          put :update, :id => @task, :task => @attr.merge(:content => 'another content')
          @task.reload
          @task.content.should_not == 'another content'
        end
      end
      describe "for author user" do
        it "should change the task's attributes" do
          test_sign_in(@user)
          put :update, :id => @task, :task => @attr.merge(:content => 'another content')
          @task.reload
          @task.content.should == 'another content'
        end
      end
    end
  end
  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory.create(:user)
      @project = Factory.create(:project)
      @status = Factory.create(:status)
      @task = @user.outcomes.create(Factory.attributes_for(:task,:user_id => @user.id,:project_id => @project.id, :status_id => @status.id))
    end
    describe "for non-signed users" do
      it "should redirect to root and show an error message" do
        delete :destroy, :id => @task
        response.should redirect_to(root_path)
        flash[:notice].should =~ /доступ запрещен/i
      end
      it "should not destroy the task" do
        lambda do
          delete :destroy, :id => @task
        end.should_not change(Task,:count)
      end 
    end
    describe "for not-author and not-admin users" do
      before(:each) do
        @bad_user = Factory.create(:user,:email => Factory.next(:email))
        test_sign_in(@bad_user)
      end
      it "should redirect to root and show an error message" do
        delete :destroy, :id => @task
        response.should redirect_to(user_path(@bad_user))
        flash[:notice].should =~ /доступ запрещен/i
      end
      it "should not destroy the task" do
        lambda do
          delete :destroy, :id => @task
        end.should_not change(Task,:count)
      end 
    end
    describe "for author" do
      it "should destroy the task" do
        test_sign_in(@user)
        lambda do
          delete :destroy, :id => @task
        end.should change(Task,:count)
      end
    end
    describe "for admin" do
      it "should destroy the task" do
        @admin = Factory.create(:admin)
        test_sign_in(@admin)
        lambda do
          delete :destroy, :id => @task
        end.should change(Task,:count)
      end
    end
  end
end
