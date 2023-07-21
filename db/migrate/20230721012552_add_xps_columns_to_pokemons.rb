class AddXpsColumnsToPokemons < ActiveRecord::Migration[6.1]
  def up
    add_column :pokemons, :current_exp, :integer, default: 0
    add_column :pokemons, :base_exp, :integer, default: -> { rand(50..350) }
    add_column :pokemons, :status, :string, default: "Wild"
    add_column :pokemons, :is_holding_lucky_egg, :boolean, default: false
    add_column :pokemons, :is_having_exp_all, :boolean, default: false
  end

  def down
    remove_column :pokemons, :current_exp
    remove_column :pokemons, :base_exp
    remove_column :pokemons, :status
    remove_column :pokemons, :is_holding_lucky_egg
    remove_column :pokemons, :is_having_exp_all
  end
end