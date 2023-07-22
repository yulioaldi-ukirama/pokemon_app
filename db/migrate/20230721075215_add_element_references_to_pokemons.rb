class AddElementReferencesToPokemons < ActiveRecord::Migration[6.1]
  def change
    add_reference :pokemons, :element_1, null: false, foreign_key: { to_table: :elements }
    add_reference :pokemons, :element_2, null: false, foreign_key: { to_table: :elements }
  end
end
