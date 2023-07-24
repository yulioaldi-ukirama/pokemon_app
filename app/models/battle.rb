class Battle < ApplicationRecord
  # Validations

  # Relations
  # has_many :battles_pokemons, dependent: :delete_all
  # has_many :pokemons, through: :battles_pokemons

  belongs_to :pokemon_1, class_name: 'Pokemon', foreign_key: 'pokemon_1_id'
  belongs_to :pokemon_2, class_name: 'Pokemon', foreign_key: 'pokemon_2_id'
end
