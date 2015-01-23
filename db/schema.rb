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

ActiveRecord::Schema.define(version: 20150126160546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_roles", force: true do |t|
    t.integer  "dce_lti_user_id"
    t.integer  "course_id"
    t.string   "role",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_roles", ["course_id"], name: "index_course_roles_on_course_id", using: :btree
  add_index "course_roles", ["dce_lti_user_id"], name: "index_course_roles_on_dce_lti_user_id", using: :btree
  add_index "course_roles", ["role"], name: "index_course_roles_on_role", using: :btree

  create_table "courses", force: true do |t|
    t.string   "title"
    t.string   "resource_link_id"
    t.boolean  "review_required",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["resource_link_id"], name: "index_courses_on_resource_link_id", unique: true, using: :btree

  create_table "dce_lti_nonces", force: true do |t|
    t.string   "nonce"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dce_lti_nonces", ["nonce"], name: "index_dce_lti_nonces_on_nonce", unique: true, using: :btree

  create_table "dce_lti_users", force: true do |t|
    t.string   "lti_user_id"
    t.string   "lis_person_contact_email_primary"
    t.string   "lis_person_name_family"
    t.string   "lis_person_name_full"
    t.string   "lis_person_name_given"
    t.string   "lis_person_sourcedid"
    t.string   "user_image"
    t.string   "roles",                            default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dce_lti_users", ["lis_person_name_full"], name: "index_dce_lti_users_on_lis_person_name_full", using: :btree

  create_table "delayed_jobs", force: true do |t|
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

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "videos", force: true do |t|
    t.integer  "dce_lti_user_id"
    t.string   "youtube_id"
    t.integer  "course_id"
    t.boolean  "approved",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["course_id", "dce_lti_user_id"], name: "index_videos_on_course_id_and_dce_lti_user_id", unique: true, using: :btree
  add_index "videos", ["dce_lti_user_id"], name: "index_videos_on_dce_lti_user_id", using: :btree

end
