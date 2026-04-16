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

ActiveRecord::Schema[8.1].define(version: 2026_04_16_115514) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assigns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.bigint "project_id", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "project_id"], name: "index_assigns_on_employee_id_and_project_id", unique: true
    t.index ["employee_id"], name: "index_assigns_on_employee_id"
    t.index ["project_id"], name: "index_assigns_on_project_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.date "attendance_date"
    t.time "check_in"
    t.time "check_out"
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_attendances_on_employee_id"
  end

  create_table "departments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.boolean "status"
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date_of_join"
    t.bigint "department_id", null: false
    t.string "name"
    t.string "role"
    t.decimal "salary", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_employees_on_department_id"
  end

  create_table "projects", force: :cascade do |t|
    t.decimal "budget", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.date "end_at"
    t.string "name"
    t.date "start_at"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "assigns", "employees"
  add_foreign_key "assigns", "projects"
  add_foreign_key "attendances", "employees"
  add_foreign_key "employees", "departments"
end
