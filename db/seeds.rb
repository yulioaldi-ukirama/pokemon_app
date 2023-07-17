# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Type.create([
  {name: "Normal"},
  {name: "Fighting"},
  {name: "Flying"},
  {name: "Poison"},
  {name: "Ground"},
  {name: "Rock"},
])

Move.create([
  {name: "Pound", power: 40, category: "Physical", power_points: 12, type_id: 1},
  {name: "Karate Chop", power: 50, category: "Special", power_points: 13, type_id: 2},
  {name: "Double Stap", power: 60, category: "Physical", power_points: 14, type_id: 3},
  {name: "Comet Punch", power: 70, category: "Physical", power_points: 15, type_id: 4},
  {name: "Mega Punch", power: 80, category: "Special", power_points: 16, type_id: 5},
])
