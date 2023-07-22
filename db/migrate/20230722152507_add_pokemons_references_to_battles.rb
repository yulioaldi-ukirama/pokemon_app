class AddPokemonsReferencesToBattles < ActiveRecord::Migration[6.1]
  def change
    add_reference :battles, :pokemon_1, null: false, foreign_key: { to_table: :pokemons }
    add_reference :battles, :pokemon_2, null: false, foreign_key: { to_table: :pokemons }
  end
end
