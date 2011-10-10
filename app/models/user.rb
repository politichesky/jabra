# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  status             :string(255)
#  icq                :integer
#  jid                :string(255)
#  skype              :string(255)
#  admin              :boolean         default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessor :password 
  attr_accessible :name, :email, :password, :password_confirmation, :status, :jid, :icq, :skype, :avatar, :notify_jabber, :notify_email
  
  has_attached_file :avatar, :styles => {:medium => "300x300", :thumb => "100x100" }
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg','image/gif','image/png']
  validates_attachment_size :avatar, :in => 1..1.megabyte
  
  has_many :incomes, :class_name => "Task", :foreign_key => "user_id"
  has_many :outcomes, :class_name => "Task", :foreign_key => "author_id"
  has_many :comments

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length => { :maximum => 30 }
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false } # FOO@bar == foo@bar
  validates :password, :presence => true,
                    :confirmation => true,
                    :length => {:within => 5..30}

  before_save :encrypt_password

  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email,submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(self.password) #or just password without self
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}") 
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
