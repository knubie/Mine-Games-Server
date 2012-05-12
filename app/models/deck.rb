class Deck < ActiveRecord::Base
	belongs_to :user
	belongs_to :match

  attr_accessible :cards, :hand

  before_create do |deck|
    cards = hand = []
    for i in 1..7 do cards << 'copper'end
    for i in 1..3 do cards << 'stone pickaxe'end
    hand = cards.sort do rand end
    for i in 1..5 do hand.delete_at 0 end
    deck.cards = cards.join(',')
    deck.hand = hand.join(',')
  end

end
