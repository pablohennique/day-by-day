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

ActiveRecord::Schema[7.0].define(version: 2023_06_09_164837) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: :cascade do |t|
    t.text "content"
    t.date "date"
    t.text "summary"
    t.string "sentiment"
    t.bigint "user_id", null: false
    t.bigint "obstacle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["obstacle_id"], name: "index_entries_on_obstacle_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "gratefulnesses", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_gratefulnesses_on_user_id"
  end

  create_table "obstacles", force: :cascade do |t|
    t.string "title"
    t.boolean "done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "overview"
  end

  create_table "recommendations", force: :cascade do |t|
    t.text "content"
    t.bigint "obstacle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["obstacle_id"], name: "index_recommendations_on_obstacle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "entries", "obstacles"
  add_foreign_key "entries", "users"
  add_foreign_key "gratefulnesses", "users"
  add_foreign_key "recommendations", "obstacles"
end
