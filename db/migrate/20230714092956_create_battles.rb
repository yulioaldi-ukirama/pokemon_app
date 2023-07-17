class CreateBattles < ActiveRecord::Migration[6.1]
  def change
    create_table :battles do |t|
      t.integer :turn, null: false
      t.boolean :is_complete, null: false, default: false

      t.timestamps
    end
  end
end