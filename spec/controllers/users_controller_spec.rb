#encoding: utf-8
require 'spec_helper'

describe UsersController do
  render_views

  describe "POST 'create'" do
    
    describe "failure" do

      before(:each) do
        @attr = { 
          :name => "",
          :email => "",
          :password => "",
          :password_confirmation => ""
        }
      end

      it "should not creare a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do

      before(:each) do
        @attr = { 
          :name => "name",
          :email => "email@example.com",
          :password => "foobar",
          :password_confirmation => "foobar"
        }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count)
      end

      it "should redirect to the user profile page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the jabra/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end
  
  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end
  end

  describe "GET 'index'" do

    describe "for non-login users" do
      it "should deny access" do
        get:index
        response.should redirect_to(root_path)
        flash[:notice].should =~ /доступ запрещен/i
      end
    end

    describe "for login users" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => "Bob", :email => "another@example.ru")
        third = Factory(:user, :name => "Bromville", :email => "another@example.net")
        @users = [@user, second, third]
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("a", :content => user.name)
        end
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should have the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do
      
      before(:each) do
        @attr = { 
          :name => "",
          :email => "",
          :password => "",
          :password_confirmation => ""
        }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { 
          :name => "michail",
          :email => "mich@mail.ru",
          :password => "barfoo",
          :password_confirmation => "barfoo"
        }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end

  describe "authentication of edit/update pages" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-login user" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should deny access to 'update'" do
        get :edit, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end

    describe "for signed-in users" do

      before(:each) do
        wrong_user = Factory(:user,:email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-login user" do
      it "shhould deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(user_path(@user))
      end
    end

    describe "as an admin user" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end
end
