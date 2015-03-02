class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :title
      t.boolean :active
      t.string :players
      t.integer :max_players
      t.integer :turn
      t.integer :phase
      t.string :decks
      t.string :stats
      t.string :battlefield
      t.string :triggers

      t.timestamps null: false
    end
  end
end
