class Pokemon < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :max_health_point, presence: true, numericality: { only_integer: true }
  validates :attack, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 100 }
  validates :defense, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 100 }
  validates :special_attack, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 100 }
  validates :special_defense, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 100 }
  validates :level, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 100 }

  # Relations
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
