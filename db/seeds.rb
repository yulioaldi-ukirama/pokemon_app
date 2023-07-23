# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

begin
  Element.create!([
  {name: "Normal"},
  {name: "Fighting"},
  {name: "Flying"},
  {name: "Poison"},
  {name: "Ground"},
  {name: "Rock"},
  {name: "Steel"},
  {name: "Fire"},
  {name: "Water"},
  {name: "Grass"},
  {name: "Electric"},
  {name: "Psychic"},
  {name: "Ice"},
  {name: "Dark"},
  ])
  p "Created #{Element.count} elements"

  Move.create!([
    {name: "Pound", power: 40, category: "Physical", power_points: 12, element_id: 1},
    {name: "Karate Chop", power: 50, category: "Special", power_points: 13, element_id: 2},
    {name: "Double Stap", power: 60, category: "Physical", power_points: 14, element_id: 3},
    {name: "Comet Punch", power: 70, category: "Physical", power_points: 15, element_id: 4},
    {name: "Mega Punch", power: 80, category: "Special", power_points: 16, element_id: 5},
    {name: "Absorb", power: 70, category: "Physical", power_points: 15, element_id: 6},
    {name: "Acid", power: 70, category: "Physical", power_points: 15, element_id: 7},
    {name: "Acid Armor", power: 70, category: "Physical", power_points: 15, element_id: 8},
    {name: "Amnesia", power: 70, category: "Physical", power_points: 15, element_id: 9},
    {name: "Aurora Beam", power: 70, category: "Physical", power_points: 15, element_id: 10},
    {name: "Barrage", power: 70, category: "Physical", power_points: 15, element_id: 11},
    {name: "Barrier", power: 70, category: "Physical", power_points: 15, element_id: 12},
    {name: "Bide", power: 70, category: "Physical", power_points: 15, element_id: 13},
    {name: "Bind", power: 70, category: "Physical", power_points: 15, element_id: 14},
    {name: "Blizzard", power: 70, category: "Physical", power_points: 15, element_id: 1},
    {name: "Body Slam", power: 70, category: "Physical", power_points: 15, element_id: 2},
    {name: "Bubble", power: 70, category: "Physical", power_points: 15, element_id: 3},
    {name: "Bubble Beam", power: 70, category: "Physical", power_points: 15, element_id: 4},
    {name: "Clamp", power: 70, category: "Physical", power_points: 15, element_id: 5},
    {name: "Confusion", power: 70, category: "Physical", power_points: 15, element_id: 6},
    {name: "Harden", power: 70, category: "Physical", power_points: 15, element_id: 7},
    {name: "Haze", power: 70, category: "Physical", power_points: 15, element_id: 8},
    {name: "Headbutt", power: 70, category: "Physical", power_points: 15, element_id: 9},
    {name: "High Jump Kick", power: 70, category: "Physical", power_points: 15, element_id: 10},
    {name: "Horn Attack", power: 70, category: "Physical", power_points: 15, element_id: 11},
    {name: "Horn Drill", power: 70, category: "Physical", power_points: 15, element_id: 12},
    {name: "Ice Beam", power: 70, category: "Physical", power_points: 15, element_id: 13},
    {name: "Ice Punch", power: 70, category: "Physical", power_points: 15, element_id: 14},
    {name: "Hypnosis", power: 70, category: "Physical", power_points: 15, element_id: 1},
    {name: "Jump Kick", power: 70, category: "Physical", power_points: 15, element_id: 2},
    {name: "Kinesis", power: 70, category: "Physical", power_points: 15, element_id: 3},
    {name: "Leech Life", power: 70, category: "Physical", power_points: 15, element_id: 4},
    {name: "Leech Seed", power: 70, category: "Physical", power_points: 15, element_id: 5},
    {name: "Leer", power: 70, category: "Physical", power_points: 15, element_id: 6},
  ])
  p "Created #{Move.count} moves"

  Species.create!([
    {name: "Flying", learn_move_ids_path: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], element_ids: [1, 2], base_attack: 16, base_defense: 12, base_special_attack: 14, base_special_defense: 11},
    {name: "Bug", learn_move_ids_path: [11, 12, 13, 14, 15, 16, 17, 18, 19, 20], element_ids: [3, 4], base_attack: 16, base_defense: 12, base_special_attack: 14, base_special_defense: 11},
    {name: "Ghost", learn_move_ids_path: [21, 22, 23, 24, 25, 26, 27, 28, 29, 30], element_ids: [5, 6], base_attack: 16, base_defense: 12, base_special_attack: 14, base_special_defense: 11},
    {name: "Dragon", learn_move_ids_path: [31, 32, 33, 34, 1, 2, 3, 8, 9, 4], element_ids: [7, 8], base_attack: 16, base_defense: 12, base_special_attack: 14, base_special_defense: 11},
    {name: "Mammals", learn_move_ids_path: [4, 3, 11, 13, 15, 16, 22, 18, 23, 14], element_ids: [7, 8], base_attack: 16, base_defense: 12, base_special_attack: 14, base_special_defense: 11},
    {name: "Reptile", learn_move_ids_path: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], element_ids: [9, 10], base_attack: 16, base_defense: 12, base_special_attack: 14, base_special_defense: 11},
    {name: "Monster", learn_move_ids_path: [11, 12, 13, 14, 15, 16, 17, 18, 19, 20], element_ids: [11, 12], base_attack: 16, base_defense: 12, base_special_attack: 14, base_special_defense: 11},
    {name: "Devil", learn_move_ids_path: [21, 22, 23, 24, 25, 26, 27, 28, 29, 30], element_ids: [13, 14], base_attack: 16, base_defense: 12, base_special_attack: 14, base_special_defense: 11},
    {name: "Fish", learn_move_ids_path: [31, 32, 33, 34, 1, 2, 3, 8, 9, 4], element_ids: [7, 10], base_attack: 16, base_defense: 12, base_special_attack: 14, base_special_defense: 11},
    {name: "Flower", learn_move_ids_path: [4, 3, 11, 13, 15, 16, 22, 18, 23, 14], element_ids: [10, 8], base_attack: 16, base_defense: 12, base_special_attack: 14, base_special_defense: 11},
  ])
  p "Created #{Species.count} specieses"

rescue ActiveRecord::RecordInvalid => e
  puts "Failed run the seeder: #{e.message}"
end

