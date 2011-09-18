class AddParamsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :string
    add_column :users, :icq, :integer
    add_column :users, :jid, :string
    add_column :users, :skype, :string
  end

  def self.down
    remove_column :users, :skype
    remove_column :users, :jid
    remove_column :users, :icq
    remove_column :users, :status
  end
end
