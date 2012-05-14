class Deck < ActiveRecord::Base
	belongs_to :user
	belongs_to :match

  attr_accessible :cards, :hand

  before_create do |deck|
    cards = hand = []
    for i in 1..7 do cards << 'copper'end
    for i in 1..3 do cards << 'stone pickaxe'end
    hand = cards.shuffle
    for i in 1..5 do hand.delete_at 0 end
    deck.cards = cards.join(',')
    deck.hand = hand.join(',')
    deck.actions = 1
  end

  def cards_array
    self.cards.split(',')
  end

  def hand_array
    self.hand.split(',')
  end

  def hand_value
    value = 0
    hand = self.hand.split(',')
    hand.each do |card|
      if card == 'copper'
        value += 1
      elsif card =='silver'
        value += 2
      elsif card == 'gold'
        value += 3
      elsif card == 'diamond'
        value += 5
      end
    end
    return value
  end

  def hand_value
    value = 0
    cards = self.cards.split(',')
    cards.each do |card|
      if card == 'copper'
        value += 1
      elsif card =='silver'
        value += 2
      elsif card == 'gold'
        value += 3
      elsif card == 'diamond'
        value += 5
      end
    end
    return value
  end

end
