class Image < ActiveRecord::Base
  belongs_to :user, :foreign_key => :owner_id
  belongs_to :project, :foreign_key => :owner_id

  has_attached_file :img, :styles => { :medium => "300x300", :thumb => "50x50", :small => "100x100" }

end
