class Pokemon < ApplicationRecord
  # Validations

  # Relations
  has_and_belongs_to_many :types
  # has_and_belongs_to_many :battles

  has_many :moves_pokemons, dependent: :delete_all
  has_many :moves, through: :moves_pokemons

  has_many :battles_pokemons, dependent: :delete_all
  has_many :battles, through: :battles_pokemons
end
