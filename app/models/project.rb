class Project < ActiveRecord::Base

  attr_accessible :title, :desc, :public

  has_one :image, :foreign_key => :owner_id, :conditions => "image_type = 'project'"
  has_many :tasks
  has_many :relations, :dependent => :destroy
  has_many :users, :through => :relations

  scope :public, where(:public => true)

  validates :title, :desc, :presence => true
  validates :title, :length => { :maximum => 30 }
  
  def create_relations(users) #create relationships between users and project
    users.each do |user,access|
      next if access.to_i == 0 #next if user not allowed from form
      Relation.create!(:project_id => self.id, :user_id => user)
    end
  end

  def update_relations(destroy,users) 
    self.relations.find_each { |r| r.destroy } #destroy old relationships
    self.create_relations(users) unless destroy.to_i == 1 # set new relationship if project was not set as public
  end

  def create_avatar(params)
    avatar = self.build_image(params)
    avatar.image_type = "project"
    avatar.save
  end

  private

  def self.get_projects_for(user)
    user.admin? ? Project.all : Project.public + user.projects #admin can see all projects, users - only the public and those to which access is
  end
  
end
