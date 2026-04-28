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

ActiveRecord::Schema[8.1].define(version: 2026_04_28_113659) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "author"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "new_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password"
    t.bigint "role_id", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_new_users_on_role_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.boolean "important"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "parking_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duration"
    t.datetime "entry_time"
    t.datetime "exit_time"
    t.bigint "parking_slot_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id", null: false
    t.index ["parking_slot_id"], name: "index_parking_sessions_on_parking_slot_id"
    t.index ["vehicle_id"], name: "index_parking_sessions_on_vehicle_id"
  end

  create_table "parking_slots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "slot_number"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "paid_at"
    t.bigint "parking_session_id", null: false
    t.string "payment_status"
    t.datetime "updated_at", null: false
    t.index ["parking_session_id"], name: "index_payments_on_parking_session_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "role_id", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_permissions_on_role_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "price"
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vehicle_number"
    t.string "vehicle_type"
  end

  add_foreign_key "new_users", "roles"
  add_foreign_key "parking_sessions", "parking_slots"
  add_foreign_key "parking_sessions", "vehicles"
  add_foreign_key "payments", "parking_sessions"
  add_foreign_key "permissions", "roles"
end
