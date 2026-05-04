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

ActiveRecord::Schema[8.1].define(version: 2026_05_01_123000) do
  create_table "books", force: :cascade do |t|
    t.string "author"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.string "isbn"
    t.decimal "purchase_price", precision: 10, scale: 2, default: "350.0", null: false
    t.decimal "rental_fee", precision: 10, scale: 2, default: "25.0", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "issues", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "balance_after", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "book_id", null: false
    t.datetime "created_at", null: false
    t.date "issue_date"
    t.decimal "previous_balance", precision: 10, scale: 2, default: "0.0", null: false
    t.date "return_date"
    t.string "transaction_type", default: "rent", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["book_id"], name: "index_issues_on_book_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "reset_password_digest"
    t.datetime "reset_password_sent_at"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "issues", "books"
  add_foreign_key "issues", "users"
end
