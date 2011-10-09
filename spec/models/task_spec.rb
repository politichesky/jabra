#encoding: utf-8
# == Schema Information
#
# Table name: tasks
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  project_id :integer
#  closed     :boolean
#  created_at :datetime
#  updated_at :datetime
#  author_id  :integer
#  status_id  :integer
#

require 'spec_helper'

describe Task do
  before(:each) do
    @attr = {
      :title => 'uniqueness title',
      :content => 'Just another uniqueness content for just another uniqueness task',
      :status_id => 1,
      :user_id => 2,
      :author_id => 1,
      :project_id => 1
    }
  end

  it "should create a new task with valid attributes" do
    Task.create!(@attr)
  end

  it "should require a title" do
    no_title_task = Task.new(@attr.merge(:title => ''))
    no_title_task.should_not be_valid
  end

  it "should require a task content" do
    empty_task = Task.new(@attr.merge(:content => ''))
    empty_task.should_not be_valid
  end

  it "should require the responsible user" do
    unresponsible_task = Task.new(@attr.merge(:user_id => ''))
    unresponsible_task.should_not be_valid
  end

  it "should require the project_id" do
    no_project_task = Task.new(@attr.merge(:project_id => ''))
    no_project_task.should_not be_valid
  end
end
