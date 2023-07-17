class BattlesController < ApplicationController
  # GET /battles
  def index
    @battles = Battle.all.includes(:pokemons)
  end

  # GET /battles/:battle_id/show
  def show
    @battle = Battle.find(params[:id])
    @pokemon = @battle.pokemon
  end

  # GET /battles/new
  def new
    @battle = Battle.new
    @pokemons = Pokemon.all
  end

  # GET /battles/:battle_id/edit
  
  # POST /battles
  def create
    # belum ada validasi data kosong
    @battle = Battle.new(battle_params)
    @battle.pokemon_ids = params[:battle][:pokemon_ids]

    @battle.turn = 0
    @battle.status = "Not Started"

    if @battle.save
      flash[:success] = "Successfully created a Battle."
      redirect_to battles_path
    else
      flash[:alert] = "Error occurred while saving the Battle."
      render :new
    end
  end


  private
  # Use callbacks to share common setup or constrains between actions.
  def set_battle
    @battle = Battle.find(param[:id])
  end

  # Only allow a list of trusted parameters through.
  def battle_params
    params.require(:battle).permit(:pokemon_ids)
  end
end
