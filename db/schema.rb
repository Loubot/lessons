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

ActiveRecord::Schema.define(version: 20150525002209) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teacher_id"
    t.binary   "time_off"
    t.integer  "student_id"
    t.integer  "review_id"
    t.integer  "subject_id"
  end

  add_index "events", ["review_id"], name: "index_events_on_review_id"

  create_table "experiences", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "teacher_id"
    t.datetime "start"
    t.datetime "end"
    t.binary   "present"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grinds", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "teacher_id"
    t.string   "subject_name"
    t.integer  "capacity"
    t.integer  "number_booked"
    t.decimal  "price",         precision: 8, scale: 2, default: 0.0, null: false
    t.datetime "start_time"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "grinds", ["subject_id"], name: "index_grinds_on_subject_id"
  add_index "grinds", ["teacher_id"], name: "index_grinds_on_teacher_id"

  create_table "identities", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["teacher_id"], name: "index_identities_on_teacher_id"

  create_table "invitations", force: :cascade do |t|
    t.integer  "inviter_id"
    t.string   "inviter_name"
    t.string   "recipient_email"
    t.string   "token"
    t.boolean  "accepted"
    t.date     "accepted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "invitations", ["inviter_id"], name: "index_invitations_on_inviter_id"
  add_index "invitations", ["token"], name: "index_invitations_on_token"

  create_table "locations", force: :cascade do |t|
    t.integer  "teacher_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "name"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["teacher_id"], name: "index_locations_on_teacher_id"

  create_table "openings", force: :cascade do |t|
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
    t.boolean  "all_day_mon",  default: false
    t.boolean  "all_day_tues", default: false
    t.boolean  "all_day_wed",  default: false
    t.boolean  "all_day_thur", default: false
    t.boolean  "all_day_fri",  default: false
    t.boolean  "all_day_sat",  default: false
    t.boolean  "all_day_sun",  default: false
  end

  add_index "openings", ["teacher_id"], name: "index_openings_on_teacher_id", unique: true

  create_table "packages", force: :cascade do |t|
    t.string   "subject_name",  default: ""
    t.integer  "teacher_id"
    t.integer  "subject_id"
    t.decimal  "price",         default: 0.0
    t.integer  "no_of_lessons", default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "packages", ["subject_id"], name: "index_packages_on_subject_id"
  add_index "packages", ["teacher_id"], name: "index_packages_on_teacher_id"

  create_table "photos", force: :cascade do |t|
    t.string   "name"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
  end

  create_table "prices", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.decimal  "price",       precision: 8, scale: 2
    t.boolean  "no_map",                              default: false
  end

  add_index "prices", ["subject_id"], name: "index_prices_on_subject_id"
  add_index "prices", ["teacher_id"], name: "index_prices_on_teacher_id"

  create_table "qualifications", force: :cascade do |t|
    t.string   "title"
    t.string   "school"
    t.datetime "start"
    t.datetime "end"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "present"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.integer  "event_id"
  end

  add_index "reviews", ["event_id"], name: "index_reviews_on_event_id"

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects_teachers", id: false, force: :cascade do |t|
    t.integer "subject_id", null: false
    t.integer "teacher_id", null: false
  end

  add_index "subjects_teachers", ["subject_id", "teacher_id"], name: "index_subjects_teachers_on_subject_id_and_teacher_id"

  create_table "teachers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "overview",               default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin"
    t.integer  "profile"
    t.boolean  "is_teacher",             default: false, null: false
    t.string   "paypal_email",           default: ""
    t.string   "stripe_access_token",    default: ""
    t.boolean  "is_active",              default: false, null: false
    t.boolean  "will_travel",            default: false, null: false
    t.string   "stripe_user_id"
    t.string   "address",                default: ""
    t.boolean  "paid_up",                default: false
    t.date     "paid_up_date"
  end

  add_index "teachers", ["email"], name: "index_teachers_on_email", unique: true
  add_index "teachers", ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true

  create_table "transactions", force: :cascade do |t|
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
    t.decimal  "amount",        precision: 8, scale: 2, default: 0.0, null: false
  end

  add_index "transactions", ["tracking_id"], name: "index_transactions_on_tracking_id", unique: true

  create_table "user_carts", force: :cascade do |t|
    t.integer  "teacher_id"
    t.integer  "student_id"
    t.text     "params"
    t.text     "tracking_id"
    t.string   "student_name",                          default: ""
    t.string   "student_email"
    t.string   "teacher_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subject_id"
    t.boolean  "multiple",                              default: false
    t.integer  "weeks",                                 default: 0
    t.string   "address",                               default: ""
    t.string   "booking_type",                          default: ""
    t.integer  "package_id",                            default: 0
    t.decimal  "amount",        precision: 8, scale: 2, default: 0.0,   null: false
    t.string   "teacher_name",                          default: ""
  end

  add_index "user_carts", ["tracking_id"], name: "index_user_carts_on_tracking_id", unique: true

end
