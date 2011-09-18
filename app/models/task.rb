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
  attr_accessible :title, :content, :user_id, :project_id
  has_many :comments
  belongs_to :user
  belongs_to :project
  belongs_to :status
end
