class RemoveColumnsFromPokemons < ActiveRecord::Migration[6.1]
  def up
    remove_column :pokemons, :stars
    remove_column :pokemons, :power
  end

  # if rollback
  def down
    add_column :pokemons, :stars, :integer
    add_column :pokemons, :power, :integer
  end
end
