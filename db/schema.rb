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

ActiveRecord::Schema.define(version: 2022_02_11_082255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animals", force: :cascade do |t|
    t.string "name"
    t.date "dob"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "size"
    t.string "sex"
    t.boolean "good_with_small_children"
    t.boolean "good_with_older_children"
    t.boolean "good_with_other_dogs"
    t.boolean "good_with_cats"
    t.boolean "can_be_left_alone_during_working_hours"
    t.boolean "apartment_friendly"
  end

  create_table "animals_breeds", id: false, force: :cascade do |t|
    t.bigint "animal_id", null: false
    t.bigint "breed_id", null: false
  end

  create_table "breeds", force: :cascade do |t|
    t.string "breed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "address"
    t.bigint "animal_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["animal_id"], name: "index_photos_on_animal_id"
  end

  add_foreign_key "photos", "animals"
end
