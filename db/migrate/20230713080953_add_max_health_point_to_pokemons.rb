class AddMaxHealthPointToPokemons < ActiveRecord::Migration[6.1]
  def change
    add_column :pokemons, :max_health_point, :integer
    rename_column :pokemons, :health_point, :current_health_point
  end
end
