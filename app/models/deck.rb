class Deck < ActiveRecord::Base
	belongs_to :user
	belongs_to :match

  attr_accessible :cards, :hand, :actions

  before_save :get_points

  before_create do |deck|
    cards = []
    hand = []
    for i in 1..7 do cards << 'copper' end
    for i in 1..3 do cards << 'stone_pickaxe' end
    cards.shuffle!
    hand = cards.pop(5)
    deck.cards = cards
    deck.hand = hand
    deck.actions = 1
    deck.points = 7
  end

  def get_points
    unless self.hand == nil or self.cards == nil
      self.points = 0
      self.hand.each do |card|
        self.points += 5 if card == 'diamond'
        self.points += 3 if card == 'gold'
        self.points += 2 if card == 'silver'
        self.points += 1 if card == 'copper'
      end
      self.cards.each do |card|
        self.points += 5 if card == 'diamond'
        self.points += 3 if card == 'gold'
        self.points += 2 if card == 'silver'
        self.points += 1 if card == 'copper'
      end
    end
  end

end
