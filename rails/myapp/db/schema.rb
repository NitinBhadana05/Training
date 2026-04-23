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

ActiveRecord::Schema[8.1].define(version: 2026_04_23_051254) do
  create_table "addresses", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.string "street"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "admin_code"
    t.datetime "created_at", null: false
    t.boolean "is_admin"
    t.datetime "updated_at", null: false
  end

  create_table "associate_orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_associate_orders_on_user_id"
  end

  create_table "associate_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "authors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
  end

  create_table "callback_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "post_id", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "courses_students", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "student_id", null: false
    t.index ["student_id", "course_id"], name: "index_courses_students_on_student_id_and_course_id", unique: true
  end

  create_table "employees", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "manager_id"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.string "grade"
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["student_id"], name: "index_enrollments_on_student_id"
  end

  create_table "entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "entryable_id", null: false
    t.string "entryable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["entryable_type", "entryable_id"], name: "index_entries_on_entryable"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "end_date"
    t.datetime "start_date"
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order2s", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "user3_id", null: false
    t.index ["user3_id"], name: "index_order2s_on_user3_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "payment_method"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "phones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  create_table "post1s", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "pratice_users", force: :cascade do |t|
    t.string "admin_code"
    t.integer "age"
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email"
    t.boolean "is_admin"
    t.boolean "is_verified"
    t.string "name"
    t.string "password"
    t.string "phone"
    t.boolean "terms_accepted"
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "verification_token"
    t.datetime "verified_at"
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.decimal "price"
    t.integer "stock"
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "signups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "terms_and_conditions"
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "user3s", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "orders_count"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "age"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "middle_name"
    t.string "name"
    t.string "password"
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "type"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "associate_orders", "users"
  add_foreign_key "books", "authors"
  add_foreign_key "comments", "posts"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "students"
  add_foreign_key "order2s", "user3s"
end
