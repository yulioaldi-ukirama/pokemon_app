class AddWinnerExpBeforeToBattles < ActiveRecord::Migration[6.1]
  def up
    add_column :battles, :winner_exp_before, :string
  end

  def down
    remove_column :battles, :winner_exp_before
  end
end
