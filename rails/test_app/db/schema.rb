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

ActiveRecord::Schema[8.1].define(version: 2026_04_15_101902) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "authors", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.date "dob"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "book_authors", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_book_authors_on_author_id"
    t.index ["book_id"], name: "index_book_authors_on_book_id"
  end

  create_table "books", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.string "isbn"
    t.string "language"
    t.integer "pages"
    t.date "published_on"
    t.bigint "publisher_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_books_on_category_id"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
  end

  create_table "borrows", force: :cascade do |t|
    t.bigint "copy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "due_at"
    t.decimal "fine"
    t.datetime "issued_at"
    t.datetime "returned_at"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["copy_id"], name: "index_borrows_on_copy_id"
    t.index ["user_id"], name: "index_borrows_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "copies", force: :cascade do |t|
    t.string "barcode"
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.decimal "price"
    t.string "shelf_location"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["barcode"], name: "index_copies_on_barcode", unique: true
    t.index ["book_id"], name: "index_copies_on_book_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active"
    t.text "address"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "phone"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "book_authors", "authors"
  add_foreign_key "book_authors", "books"
  add_foreign_key "books", "categories"
  add_foreign_key "books", "publishers"
  add_foreign_key "borrows", "copies"
  add_foreign_key "borrows", "users"
  add_foreign_key "copies", "books"
end
