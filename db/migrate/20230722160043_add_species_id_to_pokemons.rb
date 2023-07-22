class AddSpeciesIdToPokemons < ActiveRecord::Migration[6.1]
  def change
    add_reference :pokemons, :species, null: false, foreign_key: true
  end
end
