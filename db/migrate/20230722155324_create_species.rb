class CreateSpecies < ActiveRecord::Migration[6.1]
  def change
    create_table :species do |t|
      t.string :name, null: false
      t.string :learn_move_ids_path, null: false
      t.string :element_ids, null: false
      t.integer :base_attack, null: false
      t.integer :base_defense, null: false
      t.integer :base_special_attack, null: false
      t.integer :base_special_defense, null: false

      t.timestamps
    end
  end
end
