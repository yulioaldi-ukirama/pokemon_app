class CreateJoinTablePokemonsBattles < ActiveRecord::Migration[6.1]
  def change
    create_join_table :pokemons, :battles do |t|
      # t.index [:pokemon_id, :battle_id]
      # t.index [:battle_id, :pokemon_id]
    end
  end
end
