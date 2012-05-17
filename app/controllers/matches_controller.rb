class MatchesController < ApplicationController
  def index
    @matches = current_user.matches
    @matches.each do |match|
      match['users'] = Array.new(match.users)
      match['users'].delete(current_user)
    end
    # match = Hash.new
    # @decks = current_user.decks
    # @decks.each do |deck|
    #   match["match"] = deck.match
    #   match["users"] = Array.new(deck.match.users)
    #   match["users"].delete(current_user)
    #   @matches << match
    # end

    render :json => @matches
  end

  def show
    @match = Match.find(params[:id])
    @deck = current_user.decks.find_by_match_id(@match.id)
    @match.mine = @match.mine_array
    @deck.hand = @deck.hand_array
    @deck.cards = @deck.cards_array
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {match: @match, deck: @deck} }
    end
  end

  def new
    if current_user
      @match = Match.new
      @list = {play_friends: [], invite_friends: []}
      @friends = JSON.parse(open("https://graph.facebook.com/me/friends?access_token=#{current_user.token}").read)
      @friends["data"].each do |friend|
        if User.exists?(uid: friend["id"]) then @list[:play_friends] << friend else @list[:invite_friends] << friend end
      end
      # if params[:data]
      #   @friends = {play_friends: [], invite_friends: []}
      #   params[:data].each do |friend|
      #     friend.each do |f|
      #       if User.exists?(uid: f["id"]) then @friends[:play_friends] << f else @friends[:invite_friends] << f end
      #     end
      #   end
      # end
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @list }
      end
    else
      redirect_to signin_path
    end

  end

  def create
    @match = Match.create
    deck = current_user.decks.create
    deck.match_id = @match.id
    deck.save
    @errors = []
    
    # Add users
    if params[:users]
      params[:users].each do |username|
        if username.empty?
          @errors << "please enter a username"
        else
          user = User.find_by_username username
          if user.nil?
            @errors << "#{username} not found"
          end
        end
      end
      if @errors.empty?
        params[:users].each do |username|
          user = User.find_by_username username
          deck = user.decks.create
          deck.match_id = @match.id
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
        deck.match_id = @match.id
        deck.save
      end
    end

    # Set up turn
    if @errors.empty?
      i = 0
      @match.players.each do |user|
        if user.id == current_user.id
          @match.turn = i
          @match.save
          break
        end
        i += 1
      end
    else
      @match.destroy
      deck.destroy
    end
    @match['users'] = Array.new(@match.users)
    @match['users'].delete(current_user)
    Pusher['test_channel'].trigger('new_match', {match: @match, errors: @errors})
    respond_to do |format|
      format.html { redirect_to @match, notice: 'Match was successfully created.' }
      format.json { render json: {match: @match, errors: @errors} }
      # format.json { render json: @match, status: :created, location: @match }
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to matches_url }
      format.json { head :no_content }
    end
  end

  def actions
    @match = Match.find(params[:id])
    if @match.current_turn == current_user
      @deck = current_user.decks.find_by_match_id(@match.id)
      @mine = @match.mine_array
      @cards = @deck.cards_array
      params[:actions].each do |action|
        if action[1]["action"] == 'draw_from_mine'

          card = @mine.pop(action[1]["amount"].to_i)
          @match.mine = @mine.join(',')

          @cards << card
          @deck.cards = @cards.join(',')
        end
      end
      @deck.actions += params[:cost].to_i

      if @deck.actions == 0 # && @deck.buys == 0
        change_turn @match
        reset_hand @deck
        @deck.actions = 1
      end
      @match.save
      @deck.save
    end

    respond_to do |format|
      format.json { render json: @match }
    end
  end

end
