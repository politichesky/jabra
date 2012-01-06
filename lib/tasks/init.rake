#encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
require 'active_record'

namespace :jabra do
  desc "Create a service models"
  task :init do
    
    def validate(object)
      if object.valid?
        object
      else
        raise "Model: " + object.class.to_s + "\n" + object.errors.to_a.join("\n")
      end
    end
    
    #valid objects
    objects = []
    
    #create status objects
    ["new","accept","done","abort"].each { |s| objects << validate(Status.new(:title => s)) }

    #create task type objects
    ["bug","request","feature"].each { |t| objects << validate(Type.new(:title => t)) }
    
    #create users access rule objects
    ["user","developer"].each { |a| objects << validate(Access.new(:title => a)) }

    #create an admin user
    objects << validate(User.new(:name => "admin", :email => "admin@example.com", :password => "123", :password_confirmation => "123", :access_id => 2, :admin => :true))
    
    #save objects
    objects.each{|o| o.save }

    puts %Q[All service models successful created! Admin login => "admin@example.com", password => "123"]
  end
end


