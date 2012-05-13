class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.text :cards
      t.text :hand
      t.integer :actions

      t.references :user
      t.references :match

      t.timestamps
    end
  end
end
