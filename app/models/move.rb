class Move < ApplicationRecord
  # Validations

  # Relations
  # has_and_belongs_to_many :pokemons

  has_many :moves_pokemons
  has_many :pokemons, through: :moves_pokemons
end
