# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Project do
  
  before(:each) do
    @attr = {
      :title => "Just another project",
      :content => "Just another project decription"
    }
  end

  it "should create a new project with valid attributes" do
    Project.create!(@attr)
  end
end
