class AddColumnsToBattles < ActiveRecord::Migration[6.1]
  def up
    add_column :battles, :winner_gained_exp, :integer
    add_column :battles, :winner_level_up_count, :integer
  end

  def down
    remove_column :battles, :winner_gained_exp
    remove_column :battles, :winner_level_up_count
  end
end
