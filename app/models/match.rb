class Match < ActiveRecord::Base
	has_many :decks
	has_many :users, :through => :decks
  attr_accessible :log, :mine, :shop

  before_create do |match|
    mine = shop = []
    for i in 1..5 do mine << 'diamond'end
    for i in 1..15 do mine << 'gold'end
    for i in 1..30 do mine << 'silver'end
    for i in 1..50 do mine << 'copper'end
    mine = mine.shuffle
    match.mine = mine.join(',')
    # Total value in mineshaft = 180
    # Total cards = 100
  end
end
