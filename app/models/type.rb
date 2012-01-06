class Type < ActiveRecord::Base
  has_many :tasks
  
  scope :without_features, where("id != 3")

  private
  
  def self.get_available_types_for(user)
    user.developer? ? Type.all : Type.without_features
  end
    
end
