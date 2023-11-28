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

ActiveRecord::Schema[7.0].define(version: 2023_11_24_133758) do
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

  create_table "answers", force: :cascade do |t|
    t.bigint "feedback_id", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "boolean_answer"
    t.integer "integer_answer"
    t.text "text_answer"
    t.index ["feedback_id"], name: "index_answers_on_feedback_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
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
    t.string "web_url"
    t.string "li_url"
    t.string "slug"
    t.integer "start_year"
    t.string "kpi_one"
    t.string "kpt_one"
    t.string "kpi_two"
    t.string "kpt_two"
    t.string "kpi_three"
    t.string "kpt_three"
    t.boolean "publish", default: false
    t.boolean "publish_logo", default: false
    t.string "airtable_id"
  end

  create_table "candidacies", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.bigint "offer_id", null: false
    t.boolean "consent", default: false
    t.boolean "employer_aware"
    t.integer "employer_ok_chance"
    t.integer "half_days_wish"
    t.date "start_date_wish"
    t.text "motivation_msg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "airtable_id"
    t.date "req_start_date"
    t.integer "req_days"
    t.string "req_periodicity"
    t.string "req_periodicity_details"
    t.text "req_description"
    t.boolean "active"
    t.date "user_validation_date"
    t.text "user_validation_message"
    t.boolean "manager_validation"
    t.date "admin_validation_date"
    t.text "admin_validation_message"
    t.integer "status", default: 0
    t.integer "origin"
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
    t.string "title"
    t.string "location"
    t.string "employer_name"
    t.boolean "employer_approved", default: false
    t.text "description"
    t.string "function"
    t.date "birth_date"
    t.text "volunteering"
    t.boolean "profile_completed", default: false
    t.text "availability_details"
    t.text "primary_cause", default: [], array: true
    t.text "secondary_cause", default: [], array: true
    t.boolean "remote_work", default: false
    t.text "comment"
    t.integer "availability"
    t.string "airtable_id"
    t.string "referent_name"
    t.string "referent_email"
    t.integer "call_status", default: 0
    t.index ["user_id"], name: "index_candidates_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.bigint "user_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
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
    t.string "phone_num"
  end

  create_table "contracts", force: :cascade do |t|
    t.string "title"
    t.string "contractable_type", null: false
    t.bigint "contractable_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "contract_type"
    t.index ["company_id"], name: "index_contracts_on_company_id"
    t.index ["contractable_type", "contractable_id"], name: "index_contracts_on_contractable"
  end

  create_table "eligibility_periods", force: :cascade do |t|
    t.string "title"
    t.date "start_date"
    t.date "end_date"
    t.text "comment"
    t.integer "status"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_eligibility_periods_on_company_id"
  end

  create_table "employee_applications", force: :cascade do |t|
    t.text "motivation_msg"
    t.text "response_msg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "candidate_id", null: false
    t.integer "status", default: 0
    t.bigint "eligibility_period_id"
    t.index ["candidate_id"], name: "index_employee_applications_on_candidate_id"
    t.index ["eligibility_period_id"], name: "index_employee_applications_on_eligibility_period_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.string "employer"
    t.string "title"
    t.string "start_date"
    t.string "end_date"
    t.bigint "candidate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_experiences_on_candidate_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "mission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_feedbacks_on_mission_id"
  end

  create_table "missions", force: :cascade do |t|
    t.bigint "candidacy_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "periodicity"
    t.integer "days_count"
    t.string "title"
    t.text "description"
    t.string "referent_name"
    t.string "referent_email"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mission_type"
    t.boolean "feedback_on"
    t.integer "feedback_step"
    t.integer "feedback_unit"
    t.date "feedback_start"
    t.integer "beneficiary_approval", default: 0
    t.integer "manager_approval", default: 0
    t.boolean "employee_approval"
    t.integer "termination_cause"
    t.text "termination_comment"
    t.boolean "time_confirmation"
    t.boolean "termination_confirmation"
    t.integer "status", default: 0
    t.integer "draft_step", default: 0
    t.index ["candidacy_id"], name: "index_missions_on_candidacy_id"
  end

  create_table "offer_bookmarks", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.bigint "offer_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_offer_bookmarks_on_offer_id"
    t.index ["offer_list_id"], name: "index_offer_bookmarks_on_offer_list_id"
  end

  create_table "offer_lists", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "offer_rules", force: :cascade do |t|
    t.integer "commitment", default: 0
    t.boolean "full_remote"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "half_days_max", default: 10
    t.integer "months_max", default: 24
    t.index ["company_id"], name: "index_offer_rules_on_company_id"
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
    t.string "commitment"
    t.string "slug"
    t.string "region"
    t.boolean "full_remote", default: false
    t.string "airtable_id"
    t.index ["beneficiary_id"], name: "index_offers_on_beneficiary_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "publish", default: false
    t.string "slug"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.integer "input_type"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_questions_on_company_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "timesheets", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.text "comment"
    t.bigint "mission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_timesheets_on_mission_id"
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
    t.bigint "company_id"
    t.string "company_role"
    t.string "authentication_token", limit: 30
    t.string "uid"
    t.string "provider"
    t.string "custom_id"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "whitelists", force: :cascade do |t|
    t.integer "input_type"
    t.string "input_format"
    t.string "custom_id"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "catch_all"
    t.boolean "pre_approval"
    t.string "first_name"
    t.string "last_name"
    t.string "title"
    t.index ["company_id"], name: "index_whitelists_on_company_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "feedbacks"
  add_foreign_key "answers", "questions"
  add_foreign_key "candidacies", "candidates"
  add_foreign_key "candidacies", "offers"
  add_foreign_key "candidates", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "contracts", "companies"
  add_foreign_key "eligibility_periods", "companies"
  add_foreign_key "employee_applications", "candidates"
  add_foreign_key "employee_applications", "eligibility_periods"
  add_foreign_key "experiences", "candidates"
  add_foreign_key "feedbacks", "missions"
  add_foreign_key "missions", "candidacies"
  add_foreign_key "offer_bookmarks", "offer_lists"
  add_foreign_key "offer_bookmarks", "offers"
  add_foreign_key "offer_rules", "companies"
  add_foreign_key "offers", "beneficiaries"
  add_foreign_key "questions", "companies"
  add_foreign_key "taggings", "tags"
  add_foreign_key "timesheets", "missions"
  add_foreign_key "users", "companies"
  add_foreign_key "whitelists", "companies"
end
