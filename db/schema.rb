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

ActiveRecord::Schema.define(version: 20141121210744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

end
