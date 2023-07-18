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

ActiveRecord::Schema.define(version: 2023_07_18_020015) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "battle_stats", force: :cascade do |t|
    t.string "name", null: false
    t.integer "stars", null: false
    t.integer "power", null: false
    t.integer "current_health_point", null: false
    t.integer "max_health_point", null: false
    t.integer "attack", null: false
    t.integer "defense", null: false
    t.integer "special_attack", null: false
    t.integer "special_defense", null: false
    t.boolean "is_winner", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "battles", force: :cascade do |t|
    t.integer "turn", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
  end

  create_table "battles_pokemons", force: :cascade do |t|
    t.bigint "battle_id", null: false
    t.bigint "pokemon_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["battle_id"], name: "index_battles_pokemons_on_battle_id"
    t.index ["pokemon_id"], name: "index_battles_pokemons_on_pokemon_id"
  end

  create_table "moves", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "power"
    t.string "category"
    t.integer "power_points"
    t.bigint "type_id", null: false
    t.index ["type_id"], name: "index_moves_on_type_id"
  end

  create_table "moves_pokemons", force: :cascade do |t|
    t.bigint "pokemon_id", null: false
    t.bigint "move_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "current_power_points"
    t.index ["move_id"], name: "index_moves_pokemons_on_move_id"
    t.index ["pokemon_id"], name: "index_moves_pokemons_on_pokemon_id"
  end

  create_table "pokemons", force: :cascade do |t|
    t.string "name", null: false
    t.integer "current_health_point", null: false
    t.integer "attack", null: false
    t.integer "defense", null: false
    t.integer "special_attack", null: false
    t.integer "special_defense", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "max_health_point"
  end

  create_table "pokemons_types", id: false, force: :cascade do |t|
    t.bigint "pokemon_id", null: false
    t.bigint "type_id", null: false
  end

  create_table "types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "battles_pokemons", "battles"
  add_foreign_key "battles_pokemons", "pokemons"
  add_foreign_key "moves", "types"
  add_foreign_key "moves_pokemons", "moves"
  add_foreign_key "moves_pokemons", "pokemons"
end
