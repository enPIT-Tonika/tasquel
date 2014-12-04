# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141204140004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "done_lists", force: true do |t|
    t.integer  "user_id"
    t.text     "tweet_id"
    t.text     "desc"
    t.boolean  "is_reply"
    t.datetime "reply_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "done_lists", ["user_id"], name: "index_done_lists_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "screen_name"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "notify",        default: false
    t.json     "json_time"
    t.integer  "medicine_num"
    t.text     "medicine_desc"
  end

end
