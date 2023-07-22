class Move < ApplicationRecord
  # Validations

  # Relations
  has_many :moves_pokemons
  has_many :pokemons, through: :moves_pokemons
  
  belongs_to :element
end
