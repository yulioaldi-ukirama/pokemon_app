class Pokemon < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :max_health_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :attack, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }
  validates :defense, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }
  validates :special_attack, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }
  validates :special_defense, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }
  validates :level, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }

  # Relations
  has_many :moves_pokemons, dependent: :delete_all
  has_many :moves, through: :moves_pokemons

  belongs_to :element_1, class_name: 'Element', foreign_key: 'element_1_id'
  belongs_to :element_2, class_name: 'Element', foreign_key: 'element_2_id'

  has_many :battles_pokemon_1, class_name: 'Battle', foreign_key: 'pokemon_1_id'
  has_many :battles_pokemon_2, class_name: 'Battle', foreign_key: 'pokemon_2_id'

  belongs_to :species
end
