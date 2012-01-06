class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :icq
      t.string :jabber
      t.string :skype
      t.string :phone
      t.string :website
      t.integer :user_id

      t.timestamps
    end
  end
end
