class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :project_id
      t.integer :status
      t.boolean :closed

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
