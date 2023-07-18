class CreateMovesPokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :moves_pokemons do |t|
      t.references :pokemon, null: false, foreign_key: true
      t.references :move, null: false, foreign_key: true

      t.timestamps
    end
  end
end
