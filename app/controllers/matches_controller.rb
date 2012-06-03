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
    if params[:users]
      params[:users].each do |username|
        if username.empty?
          errors << "please enter a username"
        else
          user = User.find_by_username username
          if user.nil?
            errors << "#{username} not found"
          else
            deck = user.decks.create
            deck.match_id = match.id
            deck.save
          end
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
      match.save
    else
      match.destroy
      deck.destroy
    end
    match['players'] = Array.new(match.users)
    match['players'].delete(current_user)
    # Pusher['mine-games'].trigger('new_match', {match: @match, errors: @errors})
    render json: {match: match, errors: errors}
  end

  # PUT /matches/1
  # PUT /matches/1.json
  def update
    match = Match.find(params[:id])
    # TODO: change the arrays to strings before saving

    if match.update_attributes(params[:match])
      render json: {error: "couldn't save"}
    else
      render json: match
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
      i = match.players.index(current_user) + 1
      if i == match.players.length
        match.turn = match.players[0].id
      else
        match.turn = match.players[i].id
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
      else
        render json: {msg: 'error updating match'}
      end
    else
      render json: {msg: 'not your turn'}
    end
  end


end
