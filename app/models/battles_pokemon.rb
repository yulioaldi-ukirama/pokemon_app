class BattlesPokemon < ApplicationRecord
  belongs_to :battle
  belongs_to :pokemon
end
