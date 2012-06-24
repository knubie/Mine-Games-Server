class DecksController < ApplicationController
  # GET /decks
  # GET /decks.json
  def index
    if params[:user_id]
      user = User.find params[:user_id]
      decks = user.decks
    else
      decks = current_user.decks
    end
    # decks = Deck.all
    render :json => decks
  end

  # GET /decks/1
  # GET /decks/1.json
  def show
    if params[:id]
      deck = Deck.find(params[:id])
    elsif params[:user_id]
      deck = Deck.find_by_user_id(params[:user_id])
    end
    render :json => deck
  end

  # PUT /decks/1
  # PUT /decks/1.json
  def update
    deck = Deck.find(params[:id])
    match = Deck.find deck.match_id


    deck.actions = params[:deck][:actions]
    deck.cards = params[:deck][:cards]
    deck.hand = params[:deck][:hand]


    if deck.save
      unless deck.user_id == current_user.id
        Pusher["#{player.id}"].trigger('update_deck', {:message => 'deck updated'})
        Pusher["#{match.id}"].trigger('update_score', {:message => 'opponent deck updated'})
      end
      render json: { error: 'deck updated successfully' }
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

end
