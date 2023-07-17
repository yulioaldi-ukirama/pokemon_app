class Type < ApplicationRecord
  # Validations

  # Relations
  has_and_belongs_to_many :pokemons
end
