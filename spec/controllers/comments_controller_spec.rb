#encoding: utf-8
require 'spec_helper'

describe CommentsController do
  
  describe "for non-signed users" do

    describe "GET 'create'" do
      it "should redirect to root and show an error message" do
        get :create
        response.should redirect_to(root_path)
        flash[:notice].should =~ /доступ запрещен/i
      end
    end

    describe "DELETE 'destroy'" do
      it "should redirect to root and show an error message" do
        pending "add rules"
      end
    end
  end
end
