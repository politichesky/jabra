#encoding: utf-8
require 'spec_helper'

describe "NavigationLinks" do

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => login_path, :content => "Войти")
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = Factory(:user, :name => "Bob", :email => "another@example.ru")
      test_sign_in(@user)
    end

    it "should have a logout link" do
      visit root_path
      response.should have_selector("a", :href => logout_path, :content => "Выйти")
    end

    it "should have a user menu" do
      visit root_path
      response.should have_selector("nav#user-menu")
    end
  end
end
