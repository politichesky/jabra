# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111224115047) do

  create_table "accesses", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "author_id"
    t.integer  "task_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "icq"
    t.string   "jabber"
    t.string   "skype"
    t.string   "phone"
    t.string   "website"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.integer  "owner_id"
    t.string   "img"
    t.string   "image_type"
    t.string   "img_file_name"
    t.string   "img_content_type"
    t.string   "img_file_size"
    t.string   "img_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.boolean  "public",     :default => false
    t.integer  "avatar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["id"], :name => "index_projects_on_id"

  create_table "relations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.integer  "project_id"
    t.integer  "status_id",  :default => 1
    t.integer  "type_id"
    t.integer  "author_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["author_id"], :name => "index_tasks_on_author_id"
  add_index "tasks", ["id"], :name => "index_tasks_on_id"
  add_index "tasks", ["project_id"], :name => "index_tasks_on_project_id"
  add_index "tasks", ["status_id"], :name => "index_tasks_on_status_id"
  add_index "tasks", ["type_id"], :name => "index_tasks_on_type_id"
  add_index "tasks", ["user_id"], :name => "index_tasks_on_user_id"

  create_table "types", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "name"
    t.integer  "access_id",       :default => 1
    t.boolean  "admin",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
