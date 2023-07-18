class Battle < ApplicationRecord
  # Validations

  # Relations
  # has_and_belongs_to_many :pokemons

  has_many :battles_pokemons, dependent: :delete_all
  has_many :pokemons, through: :battles_pokemons
end
