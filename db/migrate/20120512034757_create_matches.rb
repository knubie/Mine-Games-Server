class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string_array :mine
      t.string_array :shop
      t.text_array :log
      t.integer :turn
      t.string :last_move

      t.timestamps
    end
  end
end
