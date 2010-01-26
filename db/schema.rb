# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100123115650) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scrape_runs", :force => true do |t|
    t.integer  "response_code"
    t.string   "last_modified"
    t.string   "etag"
    t.string   "content_type"
    t.integer  "content_length"
    t.text     "response_header"
    t.text     "uri"
    t.text     "file_path"
    t.text     "git_path"
    t.string   "git_commit_sha"
    t.integer  "scraper_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scrape_runs", ["scraper_id"], :name => "index_scrape_runs_on_scraper_id"

  create_table "scrapers", :force => true do |t|
    t.string   "name"
    t.text     "uri"
    t.string   "last_modified"
    t.string   "etag"
    t.boolean  "pdftotext_layout"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

end
