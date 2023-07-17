class AddTypeIdToMoves < ActiveRecord::Migration[6.1]
  def change
    add_reference :moves, :type, null: false, foreign_key: true
  end
end
