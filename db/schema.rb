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

ActiveRecord::Schema.define(version: 20170613125505) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.decimal  "cash",              default: "0.0"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.decimal  "asset",             default: "0.0"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.index ["cash", "asset"], name: "index_accounts_on_cash_and_asset"
    t.index ["user_id", "updated_at"], name: "index_accounts_on_user_id_and_updated_at"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.string   "code"
    t.integer  "account_id"
    t.integer  "volume"
    t.integer  "activated_volume"
    t.decimal  "total_cost"
    t.string   "company"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["account_id", "code"], name: "index_inventories_on_account_id_and_code"
    t.index ["account_id"], name: "index_inventories_on_account_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "code"
    t.string   "order_type"
    t.integer  "account_id"
    t.integer  "volume"
    t.decimal  "price"
    t.decimal  "total_cost"
    t.boolean  "executed",    default: false
    t.datetime "executed_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["account_id", "created_at"], name: "index_orders_on_account_id_and_created_at"
    t.index ["account_id"], name: "index_orders_on_account_id"
    t.index ["executed_at", "code"], name: "index_orders_on_executed_at_and_code"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.string   "gender"
    t.string   "education"
    t.string   "marital"
    t.string   "nationality"
    t.string   "bank"
    t.string   "bankaddress"
    t.string   "bankaccount"
    t.string   "tel"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
