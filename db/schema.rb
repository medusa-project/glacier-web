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

ActiveRecord::Schema.define(version: 20161206221119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archive_file_info_joins", force: :cascade do |t|
    t.integer "archive_id",   null: false
    t.integer "file_info_id", null: false
    t.index ["archive_id", "file_info_id"], name: "index_archive_file_info_joins_on_archive_id_and_file_info_id", unique: true, using: :btree
    t.index ["file_info_id"], name: "index_archive_file_info_joins_on_file_info_id", using: :btree
  end

  create_table "archives", force: :cascade do |t|
    t.integer  "root_id"
    t.integer  "count"
    t.decimal  "size"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "amazon_archive_id"
    t.index ["amazon_archive_id"], name: "index_archives_on_amazon_archive_id", using: :btree
    t.index ["root_id"], name: "index_archives_on_root_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "file_infos", force: :cascade do |t|
    t.integer  "root_id"
    t.text     "path",                            null: false
    t.decimal  "size",                            null: false
    t.integer  "mtime",                           null: false
    t.boolean  "needs_archiving", default: true,  null: false
    t.boolean  "deleted",         default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["deleted"], name: "index_file_infos_on_deleted", using: :btree
    t.index ["needs_archiving"], name: "index_file_infos_on_needs_archiving", using: :btree
    t.index ["path"], name: "index_file_infos_on_path", using: :btree
    t.index ["root_id", "path"], name: "index_file_infos_on_root_id_and_path", unique: true, using: :btree
    t.index ["root_id"], name: "index_file_infos_on_root_id", using: :btree
  end

  create_table "job_archive_backups", force: :cascade do |t|
    t.string   "state"
    t.string   "manifest"
    t.integer  "archive_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "message"
    t.index ["archive_id"], name: "index_job_archive_backups_on_archive_id", using: :btree
  end

  create_table "job_root_backups", force: :cascade do |t|
    t.integer  "root_id"
    t.string   "state",      default: "start", null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "priority",                     null: false
    t.text     "message"
    t.index ["root_id"], name: "index_job_root_backups_on_root_id", unique: true, using: :btree
    t.index ["state"], name: "index_job_root_backups_on_state", using: :btree
  end

  create_table "roots", force: :cascade do |t|
    t.string   "path",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_roots_on_path", unique: true, using: :btree
  end

  add_foreign_key "archive_file_info_joins", "archives"
  add_foreign_key "archive_file_info_joins", "file_infos"
  add_foreign_key "archives", "roots"
  add_foreign_key "file_infos", "roots"
  add_foreign_key "job_archive_backups", "archives"
  add_foreign_key "job_root_backups", "roots"
end
