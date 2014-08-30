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

ActiveRecord::Schema.define(version: 20140830010606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "assignments", force: true do |t|
    t.integer  "timeslot_id"
    t.integer  "boat_id"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["boat_id"], name: "index_assignments_on_boat_id", using: :btree
  add_index "assignments", ["timeslot_id"], name: "index_assignments_on_timeslot_id", using: :btree

  create_table "boats", force: true do |t|
    t.string   "name"
    t.integer  "capacity"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings", force: true do |t|
    t.integer  "timeslot_id"
    t.integer  "size"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "boat_id"
  end

  add_index "bookings", ["boat_id"], name: "index_bookings_on_boat_id", using: :btree
  add_index "bookings", ["timeslot_id"], name: "index_bookings_on_timeslot_id", using: :btree

  create_table "timeslots", force: true do |t|
    t.datetime "start_time"
    t.integer  "duration"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
