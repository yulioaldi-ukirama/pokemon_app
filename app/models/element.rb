class Element < ApplicationRecord
  # Validations 

  # Relations
  belongs_to :move

  has_many :pokemons_element_1, class_name: 'Pokemon', foreign_key: 'element_1_id'
  has_many :pokemons_element_2, class_name: 'Pokemon', foreign_key: 'element_2_id'
end
