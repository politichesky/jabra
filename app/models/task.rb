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
  attr_accessible :title, :content, :user_id, :project_id, :status_id, :attach # status_id opened for FactoryGirl! TODO: think how i want to set statuses
  has_attached_file :attach, :url => "#{RAILS_ROOT}/tmp/myfile_#{Process.pid}" 
  validates_attachment_content_type :attach, :content_type => ['image/jpeg','application/vnd.ms-excel','application/msword','image/gif','text/html','text/plain','image/bmp','image/png']
  validates_attachment_size :attach, :in => 1..1.megabyte
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
