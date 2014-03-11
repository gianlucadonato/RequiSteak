# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140311171855) do

  create_table "components", force: true do |t|
    t.string   "title",               null: false
    t.text     "description"
    t.text     "use"
    t.text     "graph"
    t.integer  "package_id"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "integration_test_id"
  end

  add_index "components", ["ancestry"], name: "index_components_on_ancestry", using: :btree

  create_table "data_fields", force: true do |t|
    t.string   "name",                           null: false
    t.string   "visibility",  default: "public"
    t.string   "data_type"
    t.text     "description"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "integration_tests", force: true do |t|
    t.string   "title",       null: false
    t.boolean  "status"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parameters", force: true do |t|
    t.string   "name"
    t.string   "parameter_type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_method_id"
    t.integer  "weight"
  end

  create_table "requirements", force: true do |t|
    t.string   "system"
    t.string   "typology",                           null: false
    t.string   "priority",                           null: false
    t.string   "hierarchy",                          null: false
    t.string   "title"
    t.boolean  "status",             default: false
    t.text     "description"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "validation_test_id"
    t.integer  "system_test_id"
  end

  add_index "requirements", ["ancestry"], name: "index_requirements_on_ancestry", using: :btree

  create_table "requirements_sources", force: true do |t|
    t.integer "requirement_id"
    t.integer "source_id"
  end

  create_table "requirements_use_cases", force: true do |t|
    t.integer "requirement_id"
    t.integer "use_case_id"
  end

  add_index "requirements_use_cases", ["requirement_id"], name: "index_requirements_use_cases_on_requirement_id", using: :btree
  add_index "requirements_use_cases", ["use_case_id"], name: "index_requirements_use_cases_on_use_case_id", using: :btree

  create_table "sources", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_tests", force: true do |t|
    t.string   "title",       null: false
    t.boolean  "status"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit_methods", force: true do |t|
    t.string   "name",                            null: false
    t.string   "visibility",   default: "public"
    t.boolean  "isQuery",      default: false
    t.string   "return_type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_id"
    t.integer  "unit_test_id"
  end

  create_table "unit_tests", force: true do |t|
    t.string   "title"
    t.boolean  "status"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: true do |t|
    t.string   "title",                          null: false
    t.text     "description"
    t.text     "use"
    t.integer  "class_id"
    t.integer  "component_id"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "typology",     default: "class"
    t.integer  "unit_test_id"
  end

  add_index "units", ["ancestry"], name: "index_units_on_ancestry", using: :btree

  create_table "use_cases", force: true do |t|
    t.string   "system",           null: false
    t.string   "hierarchy",        null: false
    t.string   "title"
    t.string   "primary_actors",   null: false
    t.string   "secondary_actors"
    t.text     "description"
    t.string   "precondition",     null: false
    t.string   "postcondition",    null: false
    t.text     "main_flow"
    t.text     "alternative_flow"
    t.text     "inclusion"
    t.text     "extension"
    t.text     "graph"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subtitle"
  end

  add_index "use_cases", ["ancestry"], name: "index_use_cases_on_ancestry", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "validation_tests", force: true do |t|
    t.string   "title",       null: false
    t.boolean  "status"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
