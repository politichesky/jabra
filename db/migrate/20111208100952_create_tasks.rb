class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :desc
      t.integer :project_id
      t.integer :status_id, :default => 1
      t.integer :type_id
      t.integer :author_id
      t.integer :user_id

      t.timestamps
    end

    add_index :tasks, :id
    add_index :tasks, :user_id
    add_index :tasks, :author_id
    add_index :tasks, :status_id
    add_index :tasks, :type_id
    add_index :tasks, :project_id
  end
end
