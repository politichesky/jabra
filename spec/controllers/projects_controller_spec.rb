#encoding: utf-8
require 'spec_helper'

describe ProjectsController do
  render_views

  describe "for non-signed users" do
    describe "GET 'index'" do
      it "should redirect to root and show error message" do
        get :index
        response.should redirect_to(root_path)
        flash[:notice] =~ /доступ запрещен/i
      end
    end

    describe "GET 'new'" do
      it "should redirect to root and show error message" do
        get :new
        response.should redirect_to(root_path)
        flash[:notice] =~ /доступ запрещен/i
      end
    end

    describe "GET 'show'" do
      before(:each) do
        @project = Factory(:project)
      end
      
      it "should redirect to root and show error message" do
        get :show, :id => @project.id
        response.should redirect_to(root_path)
        flash[:notice] =~ /доступ запрещен/i
      end
    end
    
    describe "POST 'create'" do
      before(:each) do
        @attr = { :title => 'some title', :content => 'some content' }
      end
      
      it "should redirect to root and show error message" do
        post :create, :project => @attr
        response.should redirect_to(root_path)
        flash[:notice] =~ /доступ запрещен/i
      end
      
      it "should not create a project" do
        lambda do
          post :create, :project => @attr
        end.should_not change(Project, :count)
      end
    end

    describe "GET 'edit'" do
      before(:each) do
        @project = Factory(:project)
      end
      
      it "should redirect to root and show error message" do
        get :edit, :id => @project.id
        response.should redirect_to(root_path)
        flash[:notice] =~ /доступ запрещен/i
      end
    end

    describe "PUT 'update'" do
      before(:each) do
        @project = Factory(:project)
        @attr = { :title => 'another title', :content => 'another content' }
      end
      
      it "should redirect to root and show error message" do
        put :update, :id => @project.id
        response.should redirect_to(root_path)
        flash[:notice] =~ /доступ запрещен/i
      end

      it "should not change projects attributes" do
        put :update, :id => @project.id, :project => @attr
        @project.reload
        @project.title.should_not == @attr[:title]
        @project.content.should_not == @attr[:content]
      end
    end
    
    describe "DELETE 'destroy'" do
      before(:each) do
        @project = Factory(:project)
      end
      
      it "should redirect to root and show error message" do
        delete :destroy, :id => @project.id
        response.should redirect_to(root_path)
        flash[:notice] =~ /доступ запрещен/i
      end

      it "should not destroy the project" do
        lambda do 
          delete :destroy, :id => @project.id
        end.should_not change(Project,:count)
      end
    end
  end
  describe "for sigup users" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @project = Factory(:project)
    end

    describe "for non-admin users" do
      describe "GET 'index'" do
        it "should show the index projects page" do
          get :index
          response.should be_success
        end
      end
      
      describe "GET 'show'" do
        it "should show the project description" do
          get :show, :id => @project.id
          response.should be_success
        end
      end

      describe "GET 'new'" do
        it "should redirect to user's profile and show error message" do
          get :new
          response.should redirect_to(user_path(@user))
          flash[:notice] =~ /доступ запрещен/i
        end
      end
      
      describe "GET 'edit'" do
        it "should redirect to user's profile and show error message" do
          get :edit, :id => @project.id
          response.should redirect_to(user_path(@user))
          flash[:notice] =~ /доступ запрещен/i
        end
      end

      describe "POST 'create'" do
        before(:each) do
          @attr = { :title => 'some title', :content => 'some content' }
        end
      
        it "should redirect to root and show error message" do
          post :create, :project => @attr
          response.should redirect_to(user_path(@user))
          flash[:notice] =~ /доступ запрещен/i
        end
      
        it "should not create a project" do
          lambda do
            post :create, :project => @attr
          end.should_not change(Project, :count)
        end
      end
      
      describe "PUT 'update'" do
        before(:each) do
          @attr = { :title => 'another title', :content => 'another content' }
        end
        
        it "should redirect to user's profile and show error message" do
          put :update, :id => @project.id
          response.should redirect_to(user_path(@user))
          flash[:notice] =~ /доступ запрещен/i
        end

        it "should not change projects attributes" do
          put :update, :id => @project.id, :project => @attr
          @project.reload
          @project.title.should_not == @attr[:title]
          @project.content.should_not == @attr[:content]
        end
      end
      
      describe "DELETE 'destroy'" do
        it "should redirect to user's profile and show error message" do
          delete :destroy, :id => @project.id
          response.should redirect_to(user_path(@user))
          flash[:notice] =~ /доступ запрещен/i
        end

        it "should not destroy the project" do
          lambda do 
            delete :destroy, :id => @project.id
          end.should_not change(Project,:count)
        end
      end
    end

    describe "for admin users" do
      before(:each) do
        @user.admin = true
      end

      
      describe "GET 'new'" do
        it "should render form for new project" do
          get :new
          response.should be_success
        end
      end
      
      describe "GET 'edit'" do
        it "should render form for edit the project" do
          get :edit, :id => @project.id
          response.should be_success
        end
      end

      describe "POST 'create'" do
        it "should create a new project" do
          @attr = { :title => 'Just title', :content => 'Just content' }
          lambda do 
            post :create, :project => @attr
          end.should change(Project,:count)
        end
      end
          
      describe "PUT 'update'" do
        it "should update the project's attributes" do
          @attr = { :title => 'another title', :content => 'another content' }
          put :update, :id => @project.id, :project => @attr
          @project.reload
          @project.title.should == @attr[:title]
          @project.content.should == @attr[:content]
        end
      end
    
      describe "DELETE 'destroy'" do
        it "should destroy the project" do
          lambda do
            delete :destroy, :id => @project.id
          end.should change(Project,:count)
        end
      end

    end
  end
end
