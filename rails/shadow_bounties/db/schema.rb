# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_06_101140) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bounties", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "last_seen"
    t.string "poster_image"
    t.integer "reward_amount"
    t.string "status"
    t.string "target_name"
    t.integer "threat_level"
    t.datetime "updated_at", null: false
  end

  create_table "hunters", force: :cascade do |t|
    t.string "alias"
    t.datetime "created_at", null: false
    t.string "rank"
    t.string "region"
    t.datetime "updated_at", null: false
  end

  create_table "missions", force: :cascade do |t|
    t.bigint "bounty_id", null: false
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.bigint "hunter_id", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["bounty_id"], name: "index_missions_on_bounty_id"
    t.index ["hunter_id"], name: "index_missions_on_hunter_id"
  end

  add_foreign_key "missions", "bounties"
  add_foreign_key "missions", "hunters"
end
