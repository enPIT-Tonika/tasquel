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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20141125123346) do
=======
ActiveRecord::Schema.define(version: 20141123140514) do
>>>>>>> 5ea6c69099a5228edd1956d8d134203cce4c2f18

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "screen_name"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
<<<<<<< HEAD
    t.boolean  "notify",       default: false
    t.integer  "medicine_num"
=======
    t.boolean  "notify",      default: false
    t.json     "json_time"
>>>>>>> 5ea6c69099a5228edd1956d8d134203cce4c2f18
  end

end
