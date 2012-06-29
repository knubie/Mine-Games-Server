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

ActiveRecord::Schema.define(:version => 20120512034757) do

  create_table "decks", :force => true do |t|
    t.string_array "cards",      :limit => 255
    t.string_array "hand",       :limit => 255
    t.integer      "actions"
    t.integer      "buys"
    t.integer      "user_id"
    t.integer      "match_id"
    t.datetime     "created_at",                :null => false
    t.datetime     "updated_at",                :null => false
  end

  create_table "matches", :force => true do |t|
    t.string_array "mine",       :limit => 255
    t.string_array "shop",       :limit => 255
    t.string_array "log",        :limit => 255
    t.integer      "turn"
    t.string       "last_move"
    t.datetime     "created_at",                :null => false
    t.datetime     "updated_at",                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
