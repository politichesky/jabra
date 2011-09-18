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

class Project < ActiveRecord::Base
  attr_accessible :title, :content
  has_many :tasks
  
  validates :title, :presence => true, :length => { :maximum => 30 }
  validates :content, :presence => true
end
