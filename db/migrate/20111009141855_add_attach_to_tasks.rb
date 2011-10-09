class AddAttachToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :attach_file_name, :string
    add_column :tasks, :attach_content_type, :string
    add_column :tasks, :attach_file_size, :integer
    add_column :tasks, :attach_updated_at, :datetime
  end

  def self.down
    remove_column :tasks, :attach_file_name
    remove_column :tasks, :attach_content_type
    remove_column :tasks, :attach_file_size
    remove_column :tasks, :attach_updated_at
  end
end
