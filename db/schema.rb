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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110327185031) do

  create_table "assignments", :force => true do |t|
    t.integer   "user_id"
    t.integer   "role_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "markets", :force => true do |t|
    t.string    "name"
    t.string    "description"
    t.date      "start_date"
    t.date      "end_date"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.datetime  "last_transaction_date"
  end

  create_table "outcomes", :force => true do |t|
    t.integer   "market_id"
    t.string    "description"
    t.decimal   "start_price"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "positions", :force => true do |t|
    t.integer   "outcome_id"
    t.integer   "user_id"
    t.decimal   "delta_user_shares"
    t.decimal   "delta_user_account_value"
    t.decimal   "total_user_shares"
    t.string    "type"
    t.decimal   "outcome_price"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.decimal   "outcome_price_post_transaction"
    t.string    "direction"
  end

  add_index "positions", ["user_id", "outcome_id"], :name => "index_positions_on_user_id_and_outcome_id"

  create_table "roles", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string    "session_id", :null => false
    t.text      "data"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_sessions", :force => true do |t|
    t.string    "username"
    t.string    "password"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string    "username"
    t.string    "email"
    t.decimal   "cash",                :default => 0.0,   :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "crypted_password",                       :null => false
    t.string    "password_salt",                          :null => false
    t.string    "persistence_token",                      :null => false
    t.integer   "login_count",         :default => 0,     :null => false
    t.integer   "failed_login_count",  :default => 0,     :null => false
    t.timestamp "last_request_at"
    t.timestamp "current_login_at"
    t.timestamp "last_login_at"
    t.string    "current_login_ip"
    t.string    "last_login_ip"
    t.boolean   "admin"
    t.boolean   "confirmed",           :default => false
    t.string    "single_access_token"
  end

end
