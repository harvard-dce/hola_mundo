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

ActiveRecord::Schema.define(version: 20160121175700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_roles", force: :cascade do |t|
    t.integer  "dce_lti_user_id"
    t.integer  "course_id"
    t.string   "role",            limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_roles", ["course_id"], name: "index_course_roles_on_course_id", using: :btree
  add_index "course_roles", ["dce_lti_user_id"], name: "index_course_roles_on_dce_lti_user_id", using: :btree
  add_index "course_roles", ["role"], name: "index_course_roles_on_role", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "resource_link_id",   limit: 255
    t.boolean  "review_required",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "upload_description", limit: 2048
    t.string   "welcome_message",    limit: 2048
  end

  add_index "courses", ["resource_link_id"], name: "index_courses_on_resource_link_id", unique: true, using: :btree

  create_table "dce_lti_nonces", force: :cascade do |t|
    t.string   "nonce",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dce_lti_nonces", ["nonce"], name: "index_dce_lti_nonces_on_nonce", unique: true, using: :btree

  create_table "dce_lti_users", force: :cascade do |t|
    t.string   "lti_user_id",                      limit: 255
    t.string   "lis_person_contact_email_primary", limit: 255
    t.string   "lis_person_name_family",           limit: 255
    t.string   "lis_person_name_full",             limit: 255
    t.string   "lis_person_name_given",            limit: 255
    t.string   "lis_person_sourcedid",             limit: 255
    t.string   "user_image",                       limit: 255
    t.string   "roles",                                        default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dce_lti_users", ["lis_person_name_full"], name: "index_dce_lti_users_on_lis_person_name_full", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "videos", force: :cascade do |t|
    t.integer  "dce_lti_user_id"
    t.string   "youtube_id",      limit: 255
    t.integer  "course_id"
    t.boolean  "approved",                     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description",     limit: 2048
    t.string   "source",                       default: "existing"
  end

  add_index "videos", ["course_id", "dce_lti_user_id"], name: "index_videos_on_course_id_and_dce_lti_user_id", unique: true, using: :btree
  add_index "videos", ["dce_lti_user_id"], name: "index_videos_on_dce_lti_user_id", using: :btree

end
