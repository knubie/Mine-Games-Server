class MatchesController < ApplicationController
  def index
  end

  def show
    @match = Match.find(params[:id])
  end

  def new
    if current_user
      @match = Match.new
      @users = User.all
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @user }
      end
    else
      redirect_to signin_path
    end

  end

  def create
    @match = Match.new
    params[:users].each do |id|
      user = User.find(id)
      deck = user.decks.create
      deck.match_id = @match.id
    end
    respond_to do |format|
      if @match.save
        sign_in @match
        format.html { redirect_to @match, notice: 'User was successfully created.' }
        format.json { render json: @match, status: :created, location: @match }
      else
        format.html { render action: "new" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
