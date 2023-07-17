class CreateBattleStats < ActiveRecord::Migration[6.1]
  def change
    create_table :battle_stats do |t|
      t.string :name, null: false
      t.integer :stars, null: false
      t.integer :power, null: false
      t.integer :current_health_point, null: false
      t.integer :max_health_point, null: false
      t.integer :attack, null: false
      t.integer :defense, null: false
      t.integer :special_attack, null: false
      t.integer :special_defense, null: false
      t.boolean :is_winner, null: false, default: false

      t.timestamps
    end
  end
end