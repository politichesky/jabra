class Comment < ActiveRecord::Base
  belongs_to :user, :foreign_key => :author_id
  has_many :childs, :class_name => "Comment", :foreign_key => :parent_id, :dependent => :destroy
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "Comment"
  belongs_to :task

  scope :without_childs, where(:parent_id => nil)

end
