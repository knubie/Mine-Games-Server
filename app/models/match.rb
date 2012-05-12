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
    mine = mine.sort do rand end
    match.mine = mine.join(',')
  end
end
