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

ActiveRecord::Schema[8.1].define(version: 2026_04_27_070000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bills", force: :cascade do |t|
    t.date "billed_on", null: false
    t.datetime "created_at", null: false
    t.bigint "issue_id", null: false
    t.decimal "late_fine", precision: 10, scale: 2, default: "0.0", null: false
    t.text "notes"
    t.date "paid_on"
    t.decimal "rent_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["issue_id"], name: "index_bills_on_issue_id"
    t.index ["user_id"], name: "index_bills_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "author", null: false
    t.integer "available_copies", default: 1, null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.decimal "daily_rent", precision: 10, scale: 2, default: "0.0", null: false
    t.text "description"
    t.string "isbn"
    t.decimal "purchase_price", precision: 10, scale: 2, default: "0.0", null: false
    t.string "title", null: false
    t.integer "total_copies", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["author"], name: "index_books_on_author"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
    t.index ["title"], name: "index_books_on_title"
  end

  create_table "issues", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.date "due_date"
    t.date "issue_date", null: false
    t.decimal "late_fine", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "rent_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.date "return_date"
    t.integer "status", default: 0, null: false
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "transaction_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["book_id"], name: "index_issues_on_book_id"
    t.index ["status"], name: "index_issues_on_status"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "full_name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "bills", "issues"
  add_foreign_key "bills", "users"
  add_foreign_key "issues", "books"
  add_foreign_key "issues", "users"
  add_foreign_key "sessions", "users"
end
