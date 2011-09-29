# == Schema Information
#
# Table name: statuses
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Status < ActiveRecord::Base

attr_accessible :content

has_many :tasks

end
