class CreateJoinTablePokemonsMoves < ActiveRecord::Migration[6.1]
  def change
    create_join_table :pokemons, :moves do |t|
      # t.index [:pokemon_id, :move_id]
      # t.index [:move_id, :pokemon_id]
    end
  end
end
