class AddWinningStatusToBattlesPokemons < ActiveRecord::Migration[6.1]
  def up
    add_column :battles_pokemons, :winning_status, :string, default: "Waiting"
  end

  def down
    remove_column :battles_pokemons, :winning_status
  end
end
