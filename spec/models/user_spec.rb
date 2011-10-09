# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  status             :string(255)
#  icq                :integer
#  jid                :string(255)
#  skype              :string(255)
#  admin              :boolean         default(FALSE)
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = { 
      :name => "Some user", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 31
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should acept valid email addresses" do
    addresses = %w[user@foo.co USER_LOOSER@foo.bar.com user.bruser@gmail.com]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo, user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do 
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject short password" do
      short = "a" * 4
      User.new(@attr.merge(:password => short, :password_confirmation => short)).should_not be_valid
    end

    it "should reject long password" do
      long = "a" * 31
      User.new(@attr.merge(:password => long, :password_confirmation => long)).should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "authenticate method" do
      
      it "should return nil on email/password mismatch" do
        User.authenticate(@attr[:email],'wrongpass').should be_nil
      end

      it "should return nil for an email address with no user" do
        User.authenticate("bar@foo.com",@attr[:password]).should be_nil
      end

      it "should return the user on email/password match" do
        User.authenticate(@attr[:email],@attr[:password]).should == @user
      end
    end
  end
end
