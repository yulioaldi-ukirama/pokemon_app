class BattlesController < ApplicationController
  # GET /battles
  def index
    @battles = Battle.all.includes(:pokemons)
  end

  # GET /battles/:battle_id/show
  def show
    @battle = Battle.find(params[:id])
    @pokemons = @battle.pokemons

    @pokemon1 = @pokemons[0]
    @pokemon2 = @pokemons[1]
    
    @types_pokemon1 = @pokemon1.types
    @types_pokemon2 = @pokemon2.types

    @moves_pokemon1 = @pokemon1.moves
    @moves_pokemon2 = @pokemon2.moves

    @pokemons_moves_a = @pokemon1.moves_pokemons
    @pokemons_moves_b = @pokemon2.moves_pokemons

    @result = "Pertarungan sedang berlangsung"
    @turn = @battle.turn.even? ? "#{@pokemon2.name}'s turn" : "#{@pokemon1.name}'s turn"
  end

  # GET /battles/new
  def new
    @battle = Battle.new
    @pokemons = Pokemon.all
  end

  
  # POST /battles
  def create
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


  # POST /battles/:battle_id/move
  def move
    @battle = Battle.find(params[:id])
    @pokemons = @battle.pokemons

    @pokemon1 = @pokemons[0]
    @pokemon2 = @pokemons[1]

    @types_pokemon1 = @pokemon1.types
    @types_pokemon2 = @pokemon2.types

    @moves_pokemon1 = @pokemon1.moves
    @moves_pokemon2 = @pokemon2.moves

    @pokemons_moves_a = @pokemon1.moves_pokemons
    @pokemons_moves_b = @pokemon2.moves_pokemons

    @attacker = Pokemon.find(params[:attacker_id])
    @defender = Pokemon.find(params[:defender_id])

    attacker_move = Move.find(params[:attacker_move_id])
    
    @battle.status = @battle.turn > 0 ? "In Progress" : "Not Started"

    @battle.turn += 1

    @move = MovesPokemon.find_by(move_id: attacker_move.id)

    if @move.current_power_points.nil?
      @move.current_power_points = attacker_move.power_points
    end
    
    @move.current_power_points -= 1
    
    # @sampe_sini = "sampe sini coyy #{@battle.turn}"
    
    @move.save
    @battle.save

    # ///////////////////////////////

    @attacker_level = @attacker.level
    @attacker_move_power = attacker_move.power
    @attacker_attack_stat = @attacker.attack
    @defender_defense_stat = @defender.defense

    if @attacker.types.any? { |type| type.id == attacker_move.type_id }
      @STAB = 1.5
    else
      @STAB = 1
    end

    @step1 = 2 * @attacker_level / 5 + 2
    @step2 = @step1 * @attacker_move_power * @attacker_attack_stat / @defender_defense_stat
    @step3 = @step2 / 50 + 2
    @step4 = @step3 * @STAB
    @damage = @step4.floor

    @defender.current_health_point -= @damage
    @defender.save

    # swswxx===/\[]

    # ///////////////////////////////

    @result = "#{@attacker.name} menyerang #{@defender.name} dengan #{attacker_move.name}."
    @turn = @battle.turn.even? ? "#{@pokemon2.name}'s turn" : "#{@pokemon1.name}'s turn"

    render :show
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
