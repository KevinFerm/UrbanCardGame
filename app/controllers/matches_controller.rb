class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]

  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.where({active: true})
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  def getCard(card)
    return Card.where({title: card})
  end

  def getDeckFromNames(cards)
    deckarray = {}
    cards.each do |x,y|
      y.each_with_index do |z,c|
        deckarray[c] = getCard(z)
      end

    end
    return deckarray.to_json
  end

  def matchmake
    if current_user
      deck = match_params[:deck]
      playerarray = {}#"[{id:#{current_user.id.to_s}, player:'#{current_user.email.to_s}', score:0, hand:[] }]"

      #puts deck
      matches = Match.where({active:true})
      matches.each do |x,y|
        players = x.players
        max_players = x.max_players
        playercount = 0
        players.each do |z,c|
          playercount + 1
        end #players.each do |z,c|

        if playercount < max_players
          #matchmake
          match = x
          playjson = players.to_json
          userjson = "{email:#{current_user.email},deck:#{deck.to_s}"
          puts userjson

        else
          #create new match

        end #if playercount < max_players

      end #matches.each do |x,y|
      if matches.empty?
        puts "NOT MATCHES HUZZAHHHHHHHHHHHHHHHHHHHHHHHHHHh"

        playerarray[0] = {}
        playerarray[0]["id"] = current_user.id
        playerarray[0]["player"] = current_user.email
        playerarray[0]["score"] = 0
        playerarray[0]["hand"] = []

        userjson = "{email:#{current_user.email},deck:#{current_user.decks}"
        druck = "[#{getDeckFromNames(deck)}]"
        Match.new({
                      active:true,
                      players: playerarray.to_json,
                      max_players: 2,
                      turn: 0,
                      decks: druck
                  }).save
        #puts userjson

        #Add new match
      end #if matches.empty?

      render nothing:true
      puts "Updated shizz plxxxxx"
    end #if current_user
  end

  def match
    if current_user
      @user = User.find(current_user.id)
      @in_match = nil
      @decks = []
      gon.decks = @user.decks.to_json
      JSON.parse(@user.decks).each do |x,y|
        @decks.push(x)
      end
      @match = Match.where({active:true})
      @match.each do |x,y|
        players = x.players
        JSON.parse(players).each do |z,c|
          puts c
          if c["player"] == @user.email
            @in_match = true
            @match = x.id

          end
        end
      end
    end
  end

  def battlefield

  end
  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(match_params)

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit!
    end
end