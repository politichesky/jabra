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

class Task < ActiveRecord::Base
  attr_accessible :title, :content, :user_id, :project_id, :status_id # status_id opened for FactoryGirl! TODO: think how i want to set statuses

  has_many :comments, :dependent => :destroy
  belongs_to :user, :foreign_key => "user_id"
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :project
  belongs_to :status

  validates :title, :presence => true, :length => {:maximum => 30}
  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :project_id, :presence => true
  
  default_scope :order => 'tasks.created_at DESC'
end
