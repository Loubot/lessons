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

ActiveRecord::Schema.define(version: 20141029144614) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teacher_id"
    t.binary   "time_off"
    t.integer  "student_id"
  end

  create_table "experiences", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "teacher_id"
    t.datetime "start"
    t.datetime "end"
    t.binary   "present"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: true do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["teacher_id"], name: "index_identities_on_teacher_id"

  create_table "openings", force: true do |t|
    t.datetime "mon_open"
    t.datetime "mon_close"
    t.datetime "tues_open"
    t.datetime "tues_close"
    t.datetime "wed_open"
    t.datetime "wed_close"
    t.datetime "thur_open"
    t.datetime "thur_close"
    t.datetime "fri_open"
    t.datetime "fri_close"
    t.datetime "sat_open"
    t.datetime "sat_close"
    t.datetime "sun_open"
    t.datetime "sun_close"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "openings", ["teacher_id"], name: "index_openings_on_teacher_id", unique: true

  create_table "photos", force: true do |t|
    t.string   "name"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
  end

  create_table "qualifications", force: true do |t|
    t.string   "title"
    t.string   "school"
    t.datetime "start"
    t.datetime "end"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "present"
  end

  create_table "reviews", force: true do |t|
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
  end

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects_teachers", id: false, force: true do |t|
    t.integer "subject_id", null: false
    t.integer "teacher_id", null: false
  end

  add_index "subjects_teachers", ["subject_id", "teacher_id"], name: "index_subjects_teachers_on_subject_id_and_teacher_id"

  create_table "teachers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "address"
    t.text     "overview"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                          default: "",    null: false
    t.string   "encrypted_password",                             default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                  default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin"
    t.float    "lat"
    t.float    "lon"
    t.integer  "profile"
    t.datetime "opening"
    t.datetime "closing"
    t.decimal  "rate",                   precision: 8, scale: 2
    t.boolean  "is_teacher",                                     default: false, null: false
    t.string   "paypal_email",                                   default: ""
    t.string   "stripe_access_token",                            default: ""
  end

  add_index "teachers", ["email"], name: "index_teachers_on_email", unique: true
  add_index "teachers", ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true

  create_table "transactions", force: true do |t|
    t.string   "sender"
    t.string   "trans_id"
    t.string   "payStripe"
    t.integer  "user_id"
    t.integer  "teacher_id"
    t.datetime "pay_date"
    t.string   "tracking_id"
    t.text     "whole_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["tracking_id"], name: "index_transactions_on_tracking_id", unique: true

  create_table "user_carts", force: true do |t|
    t.integer  "teacher_id"
    t.integer  "student_id"
    t.text     "params"
    t.text     "tracking_id"
    t.string   "student_name",  default: ""
    t.string   "student_email"
    t.string   "teacher_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_carts", ["tracking_id"], name: "index_user_carts_on_tracking_id", unique: true

end
