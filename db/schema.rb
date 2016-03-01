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

ActiveRecord::Schema.define(version: 20160301121759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.string   "provider",               null: false
    t.string   "uid",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    default: 1, null: false
  end

  add_index "authentications", ["provider", "uid"], name: "index_authentications_on_provider_and_uid", using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer  "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_locales", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "language_id"
  end

  add_index "category_locales", ["category_id"], name: "index_category_locales_on_category_id", using: :btree
  add_index "category_locales", ["language_id"], name: "index_category_locales_on_language_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "name_en"
    t.integer  "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "email",            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "is_admin",         default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "category_locales", "categories"
  add_foreign_key "category_locales", "languages"
end
