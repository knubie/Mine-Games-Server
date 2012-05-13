class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.text :mine
      t.text :shop
      t.text :log
      t.integer :turn

      t.timestamps
    end
  end
end
