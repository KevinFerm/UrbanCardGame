class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :title
      t.string :img
      t.string :desc
      t.integer :cost
      t.string :type
      t.string :start
      t.string :upkeep
      t.string :downkeep
      t.string :main
      t.string :end

      t.timestamps null: false
    end
  end
end
