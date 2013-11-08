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

ActiveRecord::Schema.define(version: 20131106212851) do

  create_table "owners", force: true do |t|
    t.integer  "github_id"
    t.string   "login"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "owners_users", force: true do |t|
    t.integer "user_id"
    t.integer "owner_id"
  end

  create_table "releases", force: true do |t|
    t.integer  "repo_id"
    t.integer  "github_id"
    t.string   "html_url"
    t.string   "tag_name"
    t.text     "body"
    t.boolean  "prerelease"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repos", force: true do |t|
    t.integer  "owner_id"
    t.integer  "github_id"
    t.integer  "github_hook_id"
    t.string   "name"
    t.string   "full_name"
    t.boolean  "active",         default: false
    t.string   "description"
    t.boolean  "private",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.string   "email"
    t.integer  "repo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "github_id",                 null: false
    t.string   "github_token"
    t.string   "login"
    t.string   "name"
    t.string   "email"
    t.string   "gravatar_id"
    t.integer  "sign_in_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
