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

ActiveRecord::Schema.define(version: 20160401221148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "division_locales", force: :cascade do |t|
    t.integer  "division_id"
    t.integer  "language_id"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "division_locales", ["division_id"], name: "index_division_locales_on_division_id", using: :btree
  add_index "division_locales", ["language_id"], name: "index_division_locales_on_language_id", using: :btree

  create_table "divisions", force: :cascade do |t|
    t.integer  "code"
    t.integer  "val"
    t.integer  "sort_order"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "divisions", ["code", "val"], name: "index_divisions_on_code_and_val", unique: true, using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "name_en"
    t.integer  "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nations", force: :cascade do |t|
    t.string   "name"
    t.string   "alpha_2_code"
    t.string   "alpha_3_code"
    t.string   "numeric_code"
    t.boolean  "is_to_ship"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "payment_vendor_locales", force: :cascade do |t|
    t.integer  "payment_vendor_id"
    t.integer  "language_id"
    t.string   "logo_image"
    t.string   "name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "payment_vendor_locales", ["language_id"], name: "index_payment_vendor_locales_on_language_id", using: :btree
  add_index "payment_vendor_locales", ["payment_vendor_id"], name: "index_payment_vendor_locales_on_payment_vendor_id", using: :btree

  create_table "payment_vendors", force: :cascade do |t|
    t.integer  "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pledge_payments", force: :cascade do |t|
    t.integer  "pledge_id"
    t.float    "amount"
    t.float    "shipping_rate"
    t.float    "total_amount"
    t.integer  "payment_method_div"
    t.integer  "payment_vendor_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "preapproval_key"
    t.integer  "status",             default: 1, null: false
  end

  add_index "pledge_payments", ["payment_vendor_id"], name: "index_pledge_payments_on_payment_vendor_id", using: :btree
  add_index "pledge_payments", ["pledge_id"], name: "index_pledge_payments_on_pledge_id", using: :btree

  create_table "pledge_shippings", force: :cascade do |t|
    t.integer  "pledge_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "tel"
    t.string   "zip_code"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "address4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "nation_id"
  end

  add_index "pledge_shippings", ["nation_id"], name: "index_pledge_shippings_on_nation_id", using: :btree
  add_index "pledge_shippings", ["pledge_id"], name: "index_pledge_shippings_on_pledge_id", using: :btree

  create_table "pledges", force: :cascade do |t|
    t.integer  "reward_id"
    t.integer  "user_id"
    t.datetime "pledged_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "pledges", ["reward_id"], name: "index_pledges_on_reward_id", using: :btree
  add_index "pledges", ["user_id"], name: "index_pledges_on_user_id", using: :btree

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
    t.string   "image"
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
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "user_id"
    t.datetime "applied_begin_date"
    t.integer  "status_div"
  end

  add_index "projects", ["category_id"], name: "index_projects_on_category_id", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "reward_contents", force: :cascade do |t|
    t.integer  "reward_id"
    t.integer  "language_id"
    t.string   "title"
    t.string   "image"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "reward_contents", ["language_id"], name: "index_reward_contents_on_language_id", using: :btree
  add_index "reward_contents", ["reward_id"], name: "index_reward_contents_on_reward_id", using: :btree

  create_table "reward_shippings", force: :cascade do |t|
    t.integer  "reward_id"
    t.integer  "nation_id"
    t.float    "shipping_rate"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "reward_shippings", ["nation_id"], name: "index_reward_shippings_on_nation_id", using: :btree
  add_index "reward_shippings", ["reward_id"], name: "index_reward_shippings_on_reward_id", using: :btree

  create_table "rewards", force: :cascade do |t|
    t.integer  "project_id"
    t.float    "price"
    t.integer  "count"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "estimated_delivery"
    t.integer  "ships_to_div"
    t.float    "default_shipping_rate"
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
  add_foreign_key "division_locales", "divisions"
  add_foreign_key "division_locales", "languages"
  add_foreign_key "payment_vendor_locales", "languages"
  add_foreign_key "payment_vendor_locales", "payment_vendors"
  add_foreign_key "pledge_payments", "payment_vendors"
  add_foreign_key "pledge_payments", "pledges"
  add_foreign_key "pledge_shippings", "nations"
  add_foreign_key "pledge_shippings", "pledges"
  add_foreign_key "pledges", "rewards"
  add_foreign_key "pledges", "users"
  add_foreign_key "project_contents", "languages"
  add_foreign_key "project_contents", "projects"
  add_foreign_key "project_headers", "languages"
  add_foreign_key "project_headers", "projects"
  add_foreign_key "project_locales", "languages"
  add_foreign_key "project_locales", "projects"
  add_foreign_key "projects", "categories"
  add_foreign_key "projects", "users"
  add_foreign_key "reward_contents", "languages"
  add_foreign_key "reward_contents", "rewards"
  add_foreign_key "reward_shippings", "nations"
  add_foreign_key "reward_shippings", "rewards"
  add_foreign_key "rewards", "projects"
end
