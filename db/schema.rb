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

ActiveRecord::Schema[7.0].define(version: 2022_09_28_151658) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "beneficiaries", force: :cascade do |t|
    t.string "name"
    t.string "cause"
    t.string "address"
    t.string "city"
    t.string "siren"
    t.string "rna"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "goal"
  end

  create_table "candidacies", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.bigint "offer_id", null: false
    t.boolean "consent", default: false
    t.string "employer_name"
    t.boolean "employer_aware"
    t.integer "employer_ok_chance"
    t.integer "half_days_wish"
    t.date "start_date_wish"
    t.text "motivation_msg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_candidacies_on_candidate_id"
    t.index ["offer_id"], name: "index_candidacies_on_offer_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.string "linkedin_url"
    t.string "phone_num"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["user_id"], name: "index_candidates_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "contact_type"
    t.string "organization"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "beneficiary_id", null: false
    t.string "title"
    t.string "location"
    t.integer "half_days_min"
    t.integer "half_days_max"
    t.integer "months_min"
    t.integer "months_max"
    t.integer "monthly_gross_salary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.boolean "publish", default: false
    t.string "offer_type"
    t.string "function"
    t.index ["beneficiary_id"], name: "index_offers_on_beneficiary_id"
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
    t.string "user_type", default: "candidate"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "candidacies", "candidates"
  add_foreign_key "candidacies", "offers"
  add_foreign_key "candidates", "users"
  add_foreign_key "offers", "beneficiaries"
end
