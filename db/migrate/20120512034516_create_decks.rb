class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string_array :cards
      t.string_array :hand
      t.integer :actions
      t.integer :buys

      t.references :user
      t.references :match

      t.timestamps
    end
  end
end
