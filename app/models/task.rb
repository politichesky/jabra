class Task < ActiveRecord::Base
  attr_accessible :title, :desc, :status_id, :project_id, :type_id

  validates :title, :desc, :project_id, :type_id, :presence => true, :on => :create
  validates :title, :length => { :maximum => 30 }, :on => :create

  belongs_to :project
  belongs_to :user, :foreign_key => "user_id"
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :status
  belongs_to :type

  has_many :comments, :dependent => :destroy
  
  default_scope :order => 'tasks.created_at DESC'

  scope :bugs, where(:type_id => 1)
  scope :features, where(:type_id => 2)
  scope :requests, where(:type_id => 3)

  scope :new_task, where(:status_id => 1)
  scope :accepted, where(:status_id => 2)
  scope :done, where(:status_id => 3)
  scope :aborted, where(:status_id => 4)
  
  def self.set_type(items,type)
    type.to_i == 0 ? items : items.where(:type_id => type)
  end

  def self.set_status(items,status)
    status.to_i == 0 ? items : items.where(:status_id => status)
  end

  def set_status(status)
    self.status_id = status
    self.save
  end

  def auto_accept
    self.author.incomes << self
    self.status_id = 2
    self.save
  end
  

  def accept(user)
    user.incomes << self
    self.status_id = 2
    self.save
  end

  def done
    self.status_id = 3
    self.save
  end

  def abort
    self.status_id = 4
    self.save
  end 
    
end
