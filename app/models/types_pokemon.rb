class TypesPokemon < ApplicationRecord
  belongs_to :type
  belongs_to :pokemon
end
