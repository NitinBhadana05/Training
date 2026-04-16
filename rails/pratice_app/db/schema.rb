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

ActiveRecord::Schema[8.1].define(version: 2026_04_16_045641) do
  create_table "marks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "exam_type"
    t.string "grade"
    t.integer "marks"
    t.integer "student_id", null: false
    t.string "subject"
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_marks_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.boolean "actie"
    t.integer "age"
    t.string "course"
    t.datetime "created_at", null: false
    t.string "email"
    t.date "enroll_on"
    t.string "name"
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
    t.string "password_digest"
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "marks", "students"
end
