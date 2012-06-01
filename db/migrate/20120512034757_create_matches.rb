class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string_array :mine
      t.string_array :shop
      t.string_array :log
      t.integer :turn

      t.timestamps
    end
  end
end
