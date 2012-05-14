module MatchesHelper

	def change_turn(match)
	  if match.turn == (match.users.length - 1)
	    match.turn = 0
	  else
	    match.turn += 1
	  end
	end

	def reset_hand(deck)
		hand = []
		cards = deck.cards_array.shuffle
		for i in 0..4
			hand << cards[i]
		end
		deck.hand = hand.join(',')
		deck.save
	end

end
