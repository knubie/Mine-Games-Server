class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def show
    @match = Match.find(params[:id])
    @decks = Deck.find_all_by_user_id(current_user.id)
    @decks.each do |d|
      if d.match_id == @match.id
        @deck = d
      end
    end

  end

  def new
    if current_user
      @match = Match.new
      if params[:data]
        @friends = {play_friends: [], invite_friends: []}
        params[:data].each do |friend|
          friend.each do |f|
            if User.exists?(uid: f["id"]) then @friends[:play_friends] << f else @friends[:invite_friends] << f end
          end
        end
      end
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @friends }
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
    if params[:users]
      params[:users].each do |uid|
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
    respond_to do |format|
      format.html { redirect_to @match, notice: 'Match was successfully created.' }
      format.json { render json: @match, status: :created, location: @match }
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to matches_url }
      format.json { head :no_content }
    end
  end
end
