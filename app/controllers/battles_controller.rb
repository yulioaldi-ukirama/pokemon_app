class BattlesController < ApplicationController
  # GET /battles
  def index
    @battles = Battle.all.includes(:pokemons)
  end

  # GET /battles/:battle_id/show
  def show
    @battle = Battle.find(params[:id])
    @pokemons = @battle.pokemons
    
    @types_pokemon1 = @pokemons[0].types
    @types_pokemon2 = @pokemons[1].types

    @moves_pokemon1 = @pokemons[0].moves
    @moves_pokemon2 = @pokemons[1].moves

    @pokemons_moves_a = @pokemons[0].moves_pokemons
    @pokemons_moves_b = @pokemons[1].moves_pokemons
  end

  # GET /battles/new
  def new
    @battle = Battle.new
    @pokemons = Pokemon.all
  end

  
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
