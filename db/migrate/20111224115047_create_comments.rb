class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.text :content
      t.integer :author_id
      t.integer :task_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
