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

ActiveRecord::Schema.define(version: 2022_05_04_034557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.integer "internal_number"
    t.integer "number"
    t.string "code_multiple"
    t.string "postal_number_fk"
    t.integer "street_fk"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "city_street_postal_codes", force: :cascade do |t|
    t.string "city"
    t.string "street"
    t.string "postal_code"
    t.string "debut_tranche"
    t.string "fin_tranche"
    t.string "paire_impaire"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "communes", force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.string "name_upper_case"
    t.date "ds_timestamp_modif"
    t.integer "canto_code_fk"
    t.string "letter_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "form_data", force: :cascade do |t|
    t.integer "number"
    t.string "street"
    t.string "postal_code"
    t.string "city"
    t.string "country"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "postal_code_cities", force: :cascade do |t|
    t.string "postal_number"
    t.string "city"
    t.string "type_pc"
    t.integer "lower_boundary"
    t.integer "upper_boundary"
    t.date "source_timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "streets", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "name_upper_case"
    t.string "mot_tri"
    t.string "indic_lieu_dit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
