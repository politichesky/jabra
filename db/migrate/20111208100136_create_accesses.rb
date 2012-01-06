class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.string :title

      t.timestamps
    end
  end
end
