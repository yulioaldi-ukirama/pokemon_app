class PokemonsController < ApplicationController
  include PokemonsHelper


  # GET /pokemons
  def index
    @pokemons = Pokemon.all
  end

  # GET /pokemons/:pokemon_id/show
  def show
    @pokemon = Pokemon.find(params[:pokemon_id])
  end

  # GET /pokemons/new
  def new
    @pokemon = Pokemon.new
  end

  # GET /pokemons/:pokemon_id/edit
  def edit
    @pokemon = Pokemon.find(params[:pokemon_id])
  end


  # POST /pokemons
  def create
    # belum ada validasi data kosong
    @pokemon = Pokemon.new(pokemon_params)
    @pokemon.current_health_point = @pokemon.max_health_point if @pokemon.current_health_point.nil?
    @pokemon.stars = stars_counter(@pokemon.power)

    if @pokemon.save
      flash[:success] = "Successfully created a pokemon."
      redirect_to pokemon_show_path(@pokemon)
    else
      flash[:alert] = "Error occurred while saving the Pokémon."
      render :new
    end
  end

  # PATCH/PUT /pokemons/:pokemon_id
  def update
    @pokemon = Pokemon.find(params[:pokemon_id])

    if @pokemon.update(pokemon_params)
      flash[:success] = "Successfully updated a pokemon."
      redirect_to pokemon_show_path(@pokemon)
    else
      flash[:alert] = "Error occurred while updating the Pokémon."
      render :new
    end
  end

  # DELETE /pokemons/:pokemon_id
  def destroy
    pokemon = Pokemon.find(params[:pokemon_id])

    if pokemon.destroy
      flash[:success] = "Successfully deleted a pokemon."
      redirect_to pokemons_index_path
    else
      flash[:alert] = "Error occurred while deleting the Pokémon."
      render :new
    end
  end

  private
  # Use callbacks to share common setup or constrains between actions.
  def set_pokemon
    @pokemon = Pokemon.find(params[:pokemon_id])
  end

  # Only allow a list of trusted parameters through.
  def pokemon_params
    params.require(:pokemon).permit(:name, :power, :current_health_point, :max_health_point, :attack, :defense, :special_attack, :special_defense)
  end
end
