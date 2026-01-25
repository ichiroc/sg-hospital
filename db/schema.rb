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

ActiveRecord::Schema[8.1].define(version: 2026_01_25_030043) do
  create_table "appointments", force: :cascade do |t|
    t.date "appointed_on", null: false
    t.string "appointed_slot", null: false
    t.date "birth_date", null: false
    t.string "consultation_purpose", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "name_kana", null: false
    t.string "patient_number"
    t.string "phone_number", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["appointed_on", "appointed_slot"], name: "index_appointments_on_appointed_on_and_appointed_slot", unique: true
  end
end
