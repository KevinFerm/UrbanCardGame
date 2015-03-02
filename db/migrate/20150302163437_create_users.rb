class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :admin
      t.integer :wins
      t.integer :losses
      t.string :decks
      t.integer :coins

      t.timestamps null: false
    end
  end
end
