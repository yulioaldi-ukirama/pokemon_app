class AddCurrentPowerPointsToMovesPokemons < ActiveRecord::Migration[6.1]
  def up
    add_column :moves_pokemons, :current_power_points, :integer
  end

  def down
    remove_column :moves_pokemons, :current_power_points
  end
end
