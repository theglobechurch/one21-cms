# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_28_143526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "church_guides", id: false, force: :cascade do |t|
    t.bigint "guide_id", null: false
    t.bigint "church_id", null: false
    t.boolean "promoted", default: false, null: false
    t.boolean "owner", default: false, null: false
    t.index ["church_id"], name: "index_church_guides_on_church_id"
    t.index ["guide_id"], name: "index_church_guides_on_guide_id"
    t.index ["promoted"], name: "index_church_guides_on_promoted"
  end

  create_table "churches", force: :cascade do |t|
    t.string "church_name", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "email"
    t.string "phone"
    t.string "url"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false, null: false
    t.bigint "graphics_id"
    t.string "church_logo_uid"
    t.string "church_logo_600_uid"
    t.string "church_logo_sq_uid"
    t.string "church_logo_sq_500_uid"
    t.string "church_logo_sq_250_uid"
    t.index ["email"], name: "index_churches_on_email", unique: true
    t.index ["graphics_id"], name: "index_churches_on_graphics_id"
    t.index ["slug"], name: "index_churches_on_slug", unique: true
    t.index ["verified"], name: "index_churches_on_verified"
  end

  create_table "graphics", force: :cascade do |t|
    t.bigint "churches_id"
    t.string "graphic_name"
    t.string "graphic_uid"
    t.string "graphic_thumbnail_uid"
    t.string "graphic_thumbnail_2x_uid"
    t.string "graphic_320_uid"
    t.string "graphic_640_uid"
    t.string "graphic_960_uid"
    t.string "graphic_1280_uid"
    t.string "graphic_1920_uid"
    t.string "graphic_2560_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["churches_id"], name: "index_graphics_on_churches_id"
  end

  create_table "guides", force: :cascade do |t|
    t.string "guide_name", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "teaser"
    t.string "description"
    t.string "copyright"
    t.boolean "highlight_first", default: false, null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "graphics_id"
    t.integer "sorting", default: 0, null: false
    t.index ["graphics_id"], name: "index_guides_on_graphics_id"
  end

  create_table "studies", force: :cascade do |t|
    t.bigint "guides_id"
    t.integer "status"
    t.string "study_name", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "description"
    t.integer "sort_order", default: 0, null: false
    t.string "recording_url"
    t.string "website_url"
    t.jsonb "passage_ref_json"
    t.jsonb "questions_json", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "graphics_id"
    t.string "study_start"
    t.string "study_end"
    t.datetime "published_at"
    t.index ["graphics_id"], name: "index_studies_on_graphics_id"
    t.index ["guides_id"], name: "index_studies_on_guides_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "churches_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "role"
    t.string "first_name"
    t.string "family_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["churches_id"], name: "index_users_on_churches_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "studies", "guides", column: "guides_id"
end
