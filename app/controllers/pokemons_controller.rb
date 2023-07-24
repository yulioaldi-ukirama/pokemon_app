class PokemonsController < ApplicationController
  include PokemonsHelper

  require 'json'


  # GET /pokemons
  def index
    @pokemons = Pokemon.all
  end

  # GET /pokemons/:pokemon_id/show
  def show
    @pokemon = Pokemon.find(params[:id])
    @element_1 = @pokemon.element_1
    @element_2 = @pokemon.element_2
    @moves = @pokemon.moves

    p "elements: #{@elements}"
  end

  # GET /pokemons/new
  def new
    @pokemon = Pokemon.new
  end

  # GET /pokemons/:pokemon_id/edit
  def edit
    @pokemon = Pokemon.find(params[:id])
  end

  # GET /pokemons/:pokemon_id/edit_types
  def edit_types
    @pokemon = Pokemon.find(params[:id])
    @types = Type.all
  end

  # GET /pokemons/:pokemon_id/edit_moves
  def edit_moves
    @pokemon = Pokemon.find(params[:id])
    @moves = Move.all
  end


  # POST /pokemons
  def create
    @pokemon = Pokemon.new(pokemon_params)
    species = Species.find(@pokemon.species_id)

    @pokemon.max_health_point = rand(50..100)
    @pokemon.current_health_point = @pokemon.max_health_point if @pokemon.current_health_point.nil?
    @pokemon.attack = species.base_attack
    @pokemon.defense = species.base_defense
    @pokemon.special_attack = species.base_special_attack
    @pokemon.special_defense = species.base_special_defense
    @pokemon.element_1_id = JSON.parse(species.element_ids)[0]
    @pokemon.element_2_id = JSON.parse(species.element_ids)[1]
    @pokemon.base_exp = rand(50..350)

    move_id = JSON.parse(species.learn_move_ids_path)[0]
    @pokemon.move_ids = move_id

    if @pokemon.save
      @pokemon.moves_pokemons.each do |moves_pokemon|
        if moves_pokemon.current_power_points.nil?
          move = Move.find(moves_pokemon.move_id)
          moves_pokemon.current_power_points = move.power_points
          moves_pokemon.save
        end
      end
      
      flash[:success] = "Successfully created a pokemon."
      redirect_to pokemon_path(@pokemon)
    else
      flash[:danger] = "Error occurred while saving the Pokémon."
      render :new
    end
  end

  # PATCH/PUT /pokemons/:pokemon_id
  def update
    @pokemon = Pokemon.find(params[:id])

    if @pokemon.update(pokemon_edit_params)
      flash[:success] = "Successfully updated a pokemon."
      redirect_to pokemon_path(@pokemon)
    else
      flash[:danger] = "Error occurred while updating the Pokémon."
      render :edit
    end
  end

  # DELETE /pokemons/:pokemon_id
  def destroy
    pokemon = Pokemon.find(params[:id])

    if pokemon.battles.ids.length != 0
      flash[:danger] =  "The registered Pokémon in a battle cannot be deleted!"
      redirect_to pokemon_path
    else
      if pokemon.destroy
        flash[:success] = "Successfully deleted a pokemon."
        redirect_to pokemons_path
      else
        flash[:danger] = "Error occurred while deleting the Pokémon."
        render :show
      end
    end
  end

  # POST /pokemons/:pokemon_id/update_types
  def update_types
    @pokemon = Pokemon.find(params[:id])
    type_ids = params[:pokemon][:type_ids]
    
    if type_ids.length < 2 || type_ids.length > 3
      flash[:danger] = "Must have at least 1 and at most 2 types selected!"
      redirect_to pokemon_edit_types_path
    else
      @pokemon.type_ids = type_ids

      if @pokemon.save
        flash[:success] = "Types were successfully added to the Pokemon."
        redirect_to pokemon_edit_moves_path(@pokemon)
      else
        flash[:danger] = "Error occurred while editing the pokemon's types."
        render :edit_moves
      end
    end
  end

  # POST /pokemons/:pokemon_id/update_moves
  def update_moves
    @pokemon = Pokemon.find(params[:id])
    move_ids = params[:pokemon][:move_ids]
    
    if move_ids.length < 2 || move_ids.length > 5
      flash[:danger] = "Must have at least 1 and at most 4 moves selected!"
      redirect_to pokemon_edit_moves_path
    else
      @pokemon.move_ids = params[:pokemon][:move_ids]
      
      if @pokemon.save
        @pokemon.moves_pokemons.each do |moves_pokemon|
          if moves_pokemon.current_power_points.nil?
            move = Move.find(moves_pokemon.move_id)
            moves_pokemon.current_power_points = move.power_points
            moves_pokemon.save
          end
        end
  
        flash[:success] = "Moves were successfully added to the Pokemon."
        redirect_to pokemon_path(@pokemon)
      else
        flash[:danger] = "No moves were selected."
        render :edit_moves
      end
    end
    
  end


  private
  # Use callbacks to share common setup or constrains between actions.
  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pokemon_params
    params.require(:pokemon).permit(:name, :species_id)
  end
  
  def pokemon_edit_params
    params.require(:pokemon).permit(:name, :max_health_point, :attack, :defense, :special_attack, :special_defense)
  end
  
  def moves_params
    params.require(:move).permit(:move_ids)
  end

  def types_params
    params.require(:type).permit(:type_ids)
  end
end
