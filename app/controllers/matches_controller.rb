class MatchesController < ApplicationController
  # GET /matches
  # GET /matches.json
  def index
    matches = current_user.matches
    matches.each do |match|
      match.mine = match.mine_array
      match['players'] = Array.new(match.users)
      match['players'].delete(current_user)
    end
    render :json => matches
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    match = Match.find(params[:id])
    match.mine = match.mine_array
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
      i = 0
      match.players.each do |user|
        if user.id == current_user.id
          match.turn = i
          match.save
          break
        end
        i += 1
      end
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
    # @user = User.find(params[:id])

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
    @match = Match.find(params[:id])
    @user.destroy

    render json: { msg: 'deleted' }
  end


end
