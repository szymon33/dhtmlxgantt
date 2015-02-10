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

ActiveRecord::Schema.define(version: 20150127125957) do

  create_table "gantt_links", force: true do |t|
    t.integer  "project_id"
    t.integer  "targetable_id"
    t.string   "targetable_type"
    t.integer  "sourceable_id"
    t.string   "sourceable_type"
    t.string   "gtype"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "gantt_links", ["project_id"], name: "index_gantt_links_on_project_id", using: :btree
  add_index "gantt_links", ["sourceable_id", "sourceable_type"], name: "index_gantt_links_on_sourceable_id_and_sourceable_type", using: :btree
  add_index "gantt_links", ["targetable_id", "targetable_type"], name: "index_gantt_links_on_targetable_id_and_targetable_type", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.date     "start_date"
    t.integer  "duration"
    t.float    "progress",   limit: 24
    t.integer  "sortorder"
    t.integer  "parent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree

end
