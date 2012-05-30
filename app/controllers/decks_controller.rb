class DecksController < ApplicationController
  # GET /decks
  # GET /decks.json
  def index
    decks = current_user.decks
    decks.each do |deck|
      deck.cards = deck.cards_array
      deck.hand = deck.hand_array
    end
    render :json => decks
  end

  # GET /decks/1
  # GET /decks/1.json
  def show
    deck = Deck.find(params[:id])
    render :json => deck
  end

  # PUT /decks/1
  # PUT /decks/1.json
  def update
    deck = Deck.find(params[:id])

    if deck.update_attributes(params[:deck])
      render json: { error: 'there was an error updating the deck' }
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

end
