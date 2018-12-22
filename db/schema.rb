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

ActiveRecord::Schema.define(version: 20181117172349) do

  create_table "childbuses", force: :cascade do |t|
    t.integer  "child_id"
    t.integer  "parent_id"
    t.string   "boarding"
    t.time     "boardingtime"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "children", force: :cascade do |t|
    t.string   "name"
    t.integer  "age"
    t.string   "gender"
    t.integer  "teacher_id"
    t.integer  "parent_id"
    t.integer  "kindergarden_id", limit: 8
    t.string   "className"
    t.integer  "classNumber"
    t.string   "image"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "parent2_id"
    t.integer  "parent3_id"
    t.string   "boarding"
    t.time     "boardingtime"
    t.string   "rfid"
  end

  create_table "dangers", force: :cascade do |t|
    t.string   "controlnumber"
    t.string   "phone"
    t.string   "address"
    t.integer  "zipcode"
    t.string   "name"
    t.string   "category"
    t.float    "x"
    t.float    "y"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "frequents", force: :cascade do |t|
    t.string   "spotname"
    t.float    "x_crd"
    t.float    "y_crd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kakaos", force: :cascade do |t|
    t.string   "user_key"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.boolean  "login"
    t.string   "lastQuestion"
    t.string   "email"
    t.string   "password"
    t.string   "selChild"
    t.string   "sido"
    t.string   "sigungu"
    t.string   "name"
  end

# Could not dump table "kindergardens" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "receipts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "applicant_id"
    t.integer  "child_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string   "sidoname"
    t.string   "sigunname"
    t.integer  "arcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "school_zones", force: :cascade do |t|
    t.string   "spotname"
    t.float    "x_crd"
    t.float    "y_crd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "usertype"
    t.string   "username"
    t.string   "gender"
    t.integer  "age"
    t.string   "telephone"
    t.integer  "kindergarden_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
