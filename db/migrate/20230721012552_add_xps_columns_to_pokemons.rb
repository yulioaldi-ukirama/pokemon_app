class AddXpsColumnsToPokemons < ActiveRecord::Migration[6.1]
  def up
    add_column :pokemons, :current_exp, :integer, default: 0
    add_column :pokemons, :base_exp, :integer, default: -> { rand(50..350) }
  end

  def down
    remove_column :pokemons, :current_exp
    remove_column :pokemons, :base_exp
  end
end