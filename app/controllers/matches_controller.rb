class MatchesController < ApplicationController
  # GET /matches
  # GET /matches.json
  def index
    matches = current_user.matches
    matches.each do |match|
      match['players'] = Array.new(match.all_players)
    end
    render :json => matches
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    match = Match.find(params[:id])
    match['players'] = Array.new(match.all_players)
    render :json => match
  end

  # POST /matches
  # POST /matches.json
  def create
    match = Match.create
    deck = current_user.decks.create
    deck.match_id = match.id
    deck.save
    errors = []
    
    # Add users
    if params[:user]
      if params[:user].empty?
        errors << "please enter a username"
      else
        user = User.find_by_username params[:user]
        if user.nil?
          errors << "#{params[:user]} not found"
        else
          deck = user.decks.create
          deck.match_id = match.id
          deck.save
        end
      end
    end

    if params[:fb_users]
      params[:fb_users].each do |uid|
        user = User.find_by_uid(uid)
        if user.nil?
          # Send invite to join game via facebook
          # Create placeholder user based on UID
        end
        deck = user.decks.create
        deck.match_id = match.id
        deck.save
      end
    end

    # Set up turn
    if errors.empty?
      match.turn = current_user.id
      match.log = ["Match created!"]
      match.save
      match['players'] = Array.new(match.all_players)
      match['players'].each do |player|
        unless player.id == current_user.id
          Pusher["#{player.id}"].trigger('new_match', match)
        end
      end
    else
      match.destroy
      deck.destroy
    end
    render json: {match: match, errors: errors}
  end

  # PUT /matches/1
  # PUT /matches/1.json
  def update
    match = Match.find(params[:id])
    match.shop = params[:match][:shop]
    match.mine = params[:match][:mine]
    match.log = params[:match][:log]
    match.last_move = params[:match][:last_move]

    if match.save
      Pusher["#{match.id}"].trigger('update', match)
      render json: match
    else
      render json: {error: "couldn't save"}
    end
    
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    match = Match.find(params[:id])
    match.destroy

    render json: { msg: 'deleted' }
  end

  def end_turn
    match = Match.find(params[:id])
    if match.turn == current_user.id

      match.shop = params[:match][:shop]
      match.mine = params[:match][:mine]
      match.log = params[:match][:log]
      match.last_move = params[:match][:last_move]

      i = match.all_players.index(current_user) + 1
      if i == match.all_players.length
        match.turn = match.all_players[0].id
      else
        match.turn = match.all_players[i].id
      end
      if match.save
        deck = current_user.decks.find_by_match_id(match.id)
        deck.hand.each do |card|
          deck.cards = deck.cards << card
        end
        deck.cards.shuffle!
        deck.hand = deck.cards.pop(5)
        deck.actions = 1
        deck.extra_spend = 0
        deck.save
        Pusher["#{match.id}"].trigger('change_turn', {:message => 'turn changed'})
        render json: {match: match, deck: deck}
        # TODO: perhaps return deck and match model instead of refetching it.
      else
        render json: {msg: 'error updating match'}
      end
    else
      render json: {msg: 'not your turn'}
    end
  end

end
