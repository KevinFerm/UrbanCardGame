class AddScoreToCards < ActiveRecord::Migration
  def change
    add_column :cards, :score, :integer
  end
end
