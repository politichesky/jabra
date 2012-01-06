class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :name, :access_id
  
  has_one :contact
  has_one :image, :foreign_key => :owner_id, :conditions => "image_type = 'user'"
  belongs_to :access
  has_many :relations, :dependent => :destroy
  has_many :projects, :through => :relations
  has_many :incomes, :class_name => "Task", :foreign_key => :user_id
  has_many :outcomes, :class_name => "Task", :foreign_key => :author_id
  has_many :comments, :foreign_key => :author_id, :dependent => :destroy

  has_secure_password
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :uniqueness => true, :format => { :with => email_regex }
  validates_presence_of :password, :on => :create
  validates :name, :presence => true, :length => { :maximum => 30 }

  def create_contact(params)
    contact = self.build_contact(params)
    unless contact.save
      false
    else
      true
    end
  end

  def update_contact(params)
    if self.contact.update_attributes(params)
      true
    else
      false
    end
  end
  
  def create_avatar(params)
    avatar = self.build_image(params)
    avatar.image_type = "user"
    avatar.save
  end

  def developer?
    self.access_id == 2
  end

end
