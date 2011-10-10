class AddNotificationAttributesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :notify_jabber, :boolean, :deafult => false
    add_column :users, :notify_email, :boolean, :deafult => false
  end

  def self.down
    remove_column :users, :notify_jabber
    remove_column :users, :notify_email
  end
end
