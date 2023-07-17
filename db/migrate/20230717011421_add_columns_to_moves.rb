class AddColumnsToMoves < ActiveRecord::Migration[6.1]
  def up
    add_column :moves, :power, :integer
    add_column :moves, :category, :string
    add_column :moves, :power_points, :integer
  end

  def down
    remove_column :moves, :power
    remove_column :moves, :category
    remove_column :moves, :power_points
  end
end
