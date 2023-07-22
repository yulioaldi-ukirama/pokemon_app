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

ActiveRecord::Schema.define(version: 2023_07_22_160043) do

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
    t.bigint "pokemon_1_id", null: false
    t.bigint "pokemon_2_id", null: false
    t.string "pokemon_1_health_point", default: "0/0"
    t.string "pokemon_2_health_point", default: "0/0"
    t.string "pokemon_1_winning_status", default: "Waiting"
    t.string "pokemon_2_winning_status", default: "Waiting"
    t.integer "pokemon_1_level"
    t.integer "pokemon_2_level"
    t.index ["pokemon_1_id"], name: "index_battles_on_pokemon_1_id"
    t.index ["pokemon_2_id"], name: "index_battles_on_pokemon_2_id"
  end

  create_table "battles_pokemons", force: :cascade do |t|
    t.bigint "battle_id", null: false
    t.bigint "pokemon_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "winning_status", default: "Waiting"
    t.index ["battle_id"], name: "index_battles_pokemons_on_battle_id"
    t.index ["pokemon_id"], name: "index_battles_pokemons_on_pokemon_id"
  end

  create_table "elements", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "moves", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "power"
    t.string "category"
    t.integer "power_points"
    t.bigint "type_id", null: false
    t.bigint "element_id", null: false
    t.index ["element_id"], name: "index_moves_on_element_id"
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
    t.integer "level", default: 1
    t.integer "current_exp", default: 0
    t.integer "base_exp", default: 219
    t.bigint "element_1_id", null: false
    t.bigint "element_2_id", null: false
    t.bigint "species_id", null: false
    t.index ["element_1_id"], name: "index_pokemons_on_element_1_id"
    t.index ["element_2_id"], name: "index_pokemons_on_element_2_id"
    t.index ["species_id"], name: "index_pokemons_on_species_id"
  end

  create_table "species", force: :cascade do |t|
    t.string "name", null: false
    t.string "learn_move_ids_path", null: false
    t.string "element_ids", null: false
    t.integer "base_attack", null: false
    t.integer "base_defense", null: false
    t.integer "base_special_attack", null: false
    t.integer "base_special_defense", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "types_pokemons", force: :cascade do |t|
    t.bigint "type_id", null: false
    t.bigint "pokemon_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pokemon_id"], name: "index_types_pokemons_on_pokemon_id"
    t.index ["type_id"], name: "index_types_pokemons_on_type_id"
  end

  add_foreign_key "battles", "pokemons", column: "pokemon_1_id"
  add_foreign_key "battles", "pokemons", column: "pokemon_2_id"
  add_foreign_key "battles_pokemons", "battles"
  add_foreign_key "battles_pokemons", "pokemons"
  add_foreign_key "moves", "elements"
  add_foreign_key "moves", "types"
  add_foreign_key "moves_pokemons", "moves"
  add_foreign_key "moves_pokemons", "pokemons"
  add_foreign_key "pokemons", "elements", column: "element_1_id"
  add_foreign_key "pokemons", "elements", column: "element_2_id"
  add_foreign_key "pokemons", "species"
  add_foreign_key "types_pokemons", "pokemons"
  add_foreign_key "types_pokemons", "types"
end
