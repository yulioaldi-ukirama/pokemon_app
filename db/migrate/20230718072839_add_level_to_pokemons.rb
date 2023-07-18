class AddLevelToPokemons < ActiveRecord::Migration[6.1]
  def up
    add_column :pokemons, :level, :integer, default: 1
  end

  def down
    remove_column :pokemons, :level
  end
end
