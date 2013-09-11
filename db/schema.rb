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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130911021326) do

  create_table "addresses", :force => true do |t|
    t.integer "user_id"
    t.integer "street_number"
    t.string  "street"
    t.string  "city"
    t.string  "country"
    t.string  "phone"
    t.string  "state"
    t.string  "zipcode"
  end

  create_table "credits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pool_id"
    t.string   "credit_code"
    t.integer  "value",       :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "accepted_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "user_id"
    t.string   "sport"
    t.string   "team_one"
    t.string   "team_two"
    t.integer  "team_one_score"
    t.integer  "team_two_score"
    t.string   "winner"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date_time"
  end

  create_table "microposts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pool_id"
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pool_id"
    t.integer  "team_one_predicted_score"
    t.integer  "team_two_predicted_score"
    t.boolean  "winner",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bet"
  end

  create_table "pools", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.string   "pool_type"
    t.string   "status"
    t.integer  "buy_in"
    t.integer  "max_players"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prizes", :force => true do |t|
    t.integer "user_id"
    t.integer "value"
    t.integer "prize_type"
    t.string  "description"
    t.integer "redeemed"
    t.integer "mailed"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "user_type",       :default => 1
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",          :default => true
  end

end
