class CreateBattlesPokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :battles_pokemons do |t|
      t.references :battle, null: false, foreign_key: true
      t.references :pokemon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
