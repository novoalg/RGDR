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

ActiveRecord::Schema.define(version: 20170117171917) do

  create_table "blogs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "content"
    t.string   "title"
    t.boolean  "active"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "content"
    t.integer  "reply_id"
    t.integer  "user_id"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.string   "location"
    t.string   "time"
    t.string   "information"
    t.boolean  "special"
    t.date     "date"
  end

  create_table "static_pages", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "about_us"
    t.string   "contact_us"
    t.string   "sidebar"
    t.string   "help"
    t.string   "home_block_one"
    t.string   "woofs_for_help"
    t.string   "event"
    t.string   "adopt"
    t.string   "foster"
    t.string   "donate"
    t.string   "special_event"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "age"
    t.string   "email"
    t.string   "address_line_one"
    t.string   "address_line_two"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "password_digest"
    t.integer  "hierarchy"
    t.string   "remember_digest"
    t.boolean  "email_confirmed",  default: false
    t.string   "confirm_token"
    t.boolean  "subscribed",       default: false
    t.boolean  "banned",           default: false
  end

end
