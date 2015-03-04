class AddSizeToCards < ActiveRecord::Migration
  def change
    add_column :cards, :size, :integer
  end
end
