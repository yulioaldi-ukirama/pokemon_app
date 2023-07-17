class AddStatusToBattles < ActiveRecord::Migration[6.1]
  def up
    add_column :battles, :status, :string
    
    remove_column :battles, :is_complete, :string
  end

  def down
    add_column :battles, :is_complete, :string

    remove_column :battles, :status, :string
  end
end