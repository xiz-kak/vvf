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

ActiveRecord::Schema.define(version: 20160304094951) do

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

  create_table "project_contents", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "language_id"
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "project_contents", ["language_id"], name: "index_project_contents_on_language_id", using: :btree
  add_index "project_contents", ["project_id"], name: "index_project_contents_on_project_id", using: :btree

  create_table "project_headers", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "language_id"
    t.string   "title"
    t.string   "image_path"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "project_headers", ["language_id"], name: "index_project_headers_on_language_id", using: :btree
  add_index "project_headers", ["project_id"], name: "index_project_headers_on_project_id", using: :btree

  create_table "project_locales", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "language_id"
    t.boolean  "is_main"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "project_locales", ["language_id"], name: "index_project_locales_on_language_id", using: :btree
  add_index "project_locales", ["project_id"], name: "index_project_locales_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "category_id"
    t.float    "goal_amount"
    t.integer  "duration_days"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "projects", ["category_id"], name: "index_projects_on_category_id", using: :btree

  create_table "reward_contents", force: :cascade do |t|
    t.integer  "reward_id"
    t.integer  "language_id"
    t.string   "title"
    t.string   "image_path"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "reward_contents", ["language_id"], name: "index_reward_contents_on_language_id", using: :btree
  add_index "reward_contents", ["reward_id"], name: "index_reward_contents_on_reward_id", using: :btree

  create_table "rewards", force: :cascade do |t|
    t.integer  "project_id"
    t.float    "price"
    t.integer  "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rewards", ["project_id"], name: "index_rewards_on_project_id", using: :btree

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
  add_foreign_key "project_contents", "languages"
  add_foreign_key "project_contents", "projects"
  add_foreign_key "project_headers", "languages"
  add_foreign_key "project_headers", "projects"
  add_foreign_key "project_locales", "languages"
  add_foreign_key "project_locales", "projects"
  add_foreign_key "projects", "categories"
  add_foreign_key "reward_contents", "languages"
  add_foreign_key "reward_contents", "rewards"
  add_foreign_key "rewards", "projects"
end
