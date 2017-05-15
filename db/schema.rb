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

ActiveRecord::Schema.define(version: 20170509154029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "slug"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "transcriptions", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "status", default: "unreviewed", null: false
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_transcriptions_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "login", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_users_on_login"
  end

  add_foreign_key "transcriptions", "projects"
end
