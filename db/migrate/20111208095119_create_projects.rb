class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :desc
      t.boolean :public, :default => false
      t.integer :avatar_id

      t.timestamps
    end

    add_index :projects, :id
  end
end
