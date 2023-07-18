class CreateTypesPokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :types_pokemons do |t|
      t.references :type, null: false, foreign_key: true
      t.references :pokemon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
