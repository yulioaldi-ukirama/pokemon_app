class AddColumnstoBattles < ActiveRecord::Migration[6.1]
  def up
    add_column :battles, :pokemon_1_health_point, :string, default: "0/0"
    add_column :battles, :pokemon_2_health_point, :string, default: "0/0"
    add_column :battles, :pokemon_1_winning_status, :string, default: "Waiting"
    add_column :battles, :pokemon_2_winning_status, :string, default: "Waiting"
    add_column :battles, :pokemon_1_level, :integer
    add_column :battles, :pokemon_2_level, :integer
  end

  def down
    remove_column :battles, :pokemon_1_health_point
    remove_column :battles, :pokemon_2_health_point
    remove_column :battles, :pokemon_1_winning_status
    remove_column :battles, :pokemon_2_winning_status
    remove_column :battles, :pokemon_1_level
    remove_column :battles, :pokemon_2_level
  end
end