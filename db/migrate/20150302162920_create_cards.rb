class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :title
      t.string :img
      t.string :desc
      t.integer :cost
      t.string :type
      t.string :effect

      t.timestamps null: false
    end
  end
end
