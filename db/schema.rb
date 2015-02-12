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

ActiveRecord::Schema.define(version: 20150212145407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rooms", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "students_count"
  end

  create_table "students", force: true do |t|
    t.integer  "new_id"
    t.string   "grade"
    t.boolean  "hispanic_latino"
    t.string   "race"
    t.string   "limited_english"
    t.boolean  "low_income"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ela_scaled"
    t.string   "ela_performance"
    t.integer  "ela_growth"
    t.integer  "math_scaled"
    t.string   "math_performance"
    t.integer  "math_growth"
    t.boolean  "sped"
    t.integer  "room_id"
    t.boolean  "access_progress"
    t.integer  "access_growth"
    t.integer  "access_performance"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
