class Pokemon < ApplicationRecord
  # Validations

  # Relations
  # has_and_belongs_to_many :types
  # has_and_belongs_to_many :battles

  has_many :moves_pokemons, dependent: :delete_all
  has_many :moves, through: :moves_pokemons

  has_many :battles_pokemons, dependent: :delete_all
  has_many :battles, through: :battles_pokemons

  has_many :types_pokemons, dependent: :delete_all
  has_many :types, through: :types_pokemons

  # Callbacks
  # after_save: set_default_value_of_current_power_points_on_moves_pokemons

  # private

  # def set_default_value_of_current_power_points_on_moves_pokemons

  # end
end
