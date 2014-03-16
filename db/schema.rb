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

ActiveRecord::Schema.define(version: 20140316085925) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "loans", force: true do |t|
    t.integer  "user_id"
    t.string   "loanee"
    t.string   "description"
    t.string   "familiarity"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "progress"
    t.string   "code"
    t.text     "button_code"
  end

  create_table "payments", force: true do |t|
    t.integer  "loan_id"
    t.integer  "sponsor_id"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "transaction_id"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.text     "full"
    t.string   "auth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
