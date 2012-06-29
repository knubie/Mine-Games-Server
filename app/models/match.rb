class Match < ActiveRecord::Base
	has_many :decks, :dependent => :destroy
	has_many :users, :through => :decks
  attr_writer :players
  attr_writer :deck
  attr_accessible :log, :mine, :shop, :last_move

  before_save :get_points

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
      shop << 'stone_pickaxe'
      shop << 'iron_pickaxe'
      shop << 'diamond_pickaxe'
      shop << 'tnt'
      shop << 'minecart'
      shop << 'headlamp'
      shop << 'gopher'
      shop << 'magnet'
      shop << 'alchemy'
      shop << 'shield'
    end
    match.shop = shop
    match.shop.sort!
    match.points = 7
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

  def get_points
    self.points = 0
    self.hand.each do |card|
      self.points += 5 if card == 'diamond'
      self.points += 3 if card == 'gold'
      self.points += 2 if card == 'silver'
      self.points += 1 if card == 'copper'
    end
  end

end
