class MatchesController < ApplicationController
  # GET /matches
  # GET /matches.json
  def index
    matches = current_user.matches
    matches.each do |match|
      match['players'] = Array.new(match.users)
      match['players'].delete(current_user)
    end
    render :json => matches
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    match = Match.find(params[:id])
    match['players'] = Array.new(match.users)
    match['players'].delete(current_user)
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
      match.log << "Match created!"
      match.save
      match['players'] = Array.new(match.users)
      match['players'].delete(current_user)
      match['players'].each do |player|
        Pusher["#{player.id}"].trigger('new_match', {:message => 'new match'})
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
    # TODO: change the arrays to strings before saving
    match.shop = params[:match][:shop]
    match.mine = params[:match][:mine]
    match.log = params[:match][:log]

    if match.save
      Pusher["#{match.id}"].trigger('update', {:message => 'match updated'})
      render json: match
    else
      render json: {error: "couldn't save"}
    end

    # respond_to do |format|
    #   if @user.update_attributes(params[:user])
    #     format.html { redirect_to @user, notice: 'User was successfully updated.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: "edit" }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
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
      i = match.all_players.index(current_user) + 1
      if i == match.all_players.length
        match.turn = match.all_players[0].id
      else
        match.turn = match.all_players[i].id
      end
      if match.save
        render json: {msg: 'turn updated'}
        deck = current_user.decks.find_by_match_id(match.id)
        deck.hand.each do |card|
          deck.cards << card
        end
        deck.cards.shuffle!
        deck.hand = deck.cards.pop(5)
        deck.actions = 1
        deck.save
        Pusher["#{match.id}"].trigger('change_turn', {:message => 'turn changed'})
      else
        render json: {msg: 'error updating match'}
      end
    else
      render json: {msg: 'not your turn'}
    end
  end


end
