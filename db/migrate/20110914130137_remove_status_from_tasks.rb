class RemoveStatusFromTasks < ActiveRecord::Migration
  def self.up
    remove_column :tasks, :status
    add_column :tasks, :status_id, :integer
  end

  def self.down
    remove_column :tasks, :status_id
    add_column :tasks, :status, :integer
  end
end
