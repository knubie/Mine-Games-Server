class Deck < ActiveRecord::Base
	belongs_to :user
	belongs_to :match

  attr_accessible :cards, :hand, :actions

  before_create do |deck|
    cards = []
    hand = []
    for i in 1..7 do cards << 'copper' end
    for i in 1..3 do cards << 'stone pickaxe' end
    cards.shuffle!
    hand = cards.pop(5)
    deck.cards = cards
    deck.hand = hand
    deck.actions = 1
  end

end
