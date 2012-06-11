class Match < ActiveRecord::Base
	has_many :decks, :dependent => :destroy
	has_many :users, :through => :decks
  attr_writer :players
  attr_writer :deck
  attr_accessible :log, :mine, :shop

  before_create do |match|
    mine = []
    shop = []
    for i in 1..5 do mine << 'diamond' end
    for i in 1..15 do mine << 'gold' end
    for i in 1..30 do mine << 'silver' end
    for i in 1..50 do mine << 'copper' end
    for i in 1..20 do mine << 'coal' end
    mine = mine.shuffle
    match.mine = mine
    for i in 1..10 do
      shop << 'stone pickaxe'
      shop << 'iron pickaxe'
      shop << 'diamond pickaxe'
      shop << 'tnt'
      shop << 'minecart'
      shop << 'headlamp'
      shop << 'gopher'
      shop << 'magnet'
      shop << 'alchemy'
    end
    match.shop = shop
    match.shop.sort!
    # Total value in mineshaft = 180
    # Total cards = 100

  end

  def mine_array
    self.mine.split(',')
  end

  def shop_array
    self.shop.split(',')
  end

  def all_players
    self.users.sort
  end

  def current_turn
    self.players[self.turn]
  end

end
