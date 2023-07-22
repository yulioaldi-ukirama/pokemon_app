class BattlesController < ApplicationController
  # GET /battles
  def index
    @battles = Battle.all.includes(:pokemons)
  end

  # GET /battles/:battle_id/show
  def show
    set_battle

    @pokemon_turn = @battle.turn.even? ? "#{@pokemon2.name}'s turn" : "#{@pokemon1.name}'s turn"
  end

  # GET /battles/new
  def new
    @battle = Battle.new
    @pokemons = Pokemon.all
  end

  
  # POST /battles
  def create
    @battle = Battle.new(battle_params)
    pokemon_ids = params[:battle][:pokemon_ids]
    
    if pokemon_ids.length != 3
      flash[:danger] = "You must select 2 Pokémons to create a battle!"
      redirect_to new_battle_path
    else
      is_death = false
      is_unable_to_move = false
      is_registered_in_another_battle = false
      @battle.pokemon_ids = pokemon_ids
      
      @battle.pokemons.each do |pokemon|
        if pokemon.current_health_point < 1
          is_death = true
        end
        
        pokemon.moves_pokemons.each do |move|
          if move.current_power_points < 1
            is_unable_to_move = true
          end
        end

        if pokemon.battles_pokemons.count > 0
          is_registered_in_another_battle = true
        end
      end
      
      # bikin function baru validation
      if is_registered_in_another_battle
        flash[:danger] = "The Pokémon you have chosen is already registered in another battle."
        redirect_to new_battle_path
      else
        if is_death
          flash[:danger] = "You must select 2 Pokemons with current HP greater than 0 point!"
          redirect_to new_battle_path
        else
          if is_unable_to_move
            flash[:danger] = "You must select 2 Pokemons with current PP of each move greater than 0 point!"
            redirect_to new_battle_path
          else
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
        end
      end
    end
  end


  # POST /battles/:battle_id/move
  def move
    # Init
    set_battle

    if @battle.status == "Completed"
      flash[:danger] = "The battle is completed. You can't use all of moves again!"
      redirect_to battle_path
    else
      @attacker = Pokemon.find(params[:attacker_id])
      @defender = Pokemon.find(params[:defender_id])

      @pokemon_turn = @battle.turn.even? ? "#{@pokemon2.name}'s turn" : "#{@pokemon1.name}'s turn"

      if @battle.turn.even? && @attacker.id != @pokemon2.id
        flash[:danger] = "Please follow the rules regarding turns!"
        redirect_to battle_path
        
        return
      end

      if !@battle.turn.even? && @attacker.id != @pokemon1.id
        flash[:danger] = "Please follow the rules regarding turns!"
        redirect_to battle_path

        return
      end

      attacker_moves_pokemon = MovesPokemon.find(params[:attacker_moves_pokemon_id])
      attacker_move = attacker_moves_pokemon.move
  
      # Turn
      @battle.status = @battle.turn > 0 ? "In Progress" : "Not Started"
      @battle.turn += 1
  
      # Move
      is_unable_to_move = false
  
      if attacker_moves_pokemon.current_power_points <= 0
        if attacker_moves_pokemon.current_power_points < 0
          attacker_moves_pokemon.current_power_points = 0
          attacker_moves_pokemon.save
        end
  
        flash[:danger] = "Can't use a move with 0 power points!"
        redirect_to battle_path
      else
        attacker_moves_pokemon.current_power_points -= 1
        
        attacker_moves_pokemon.save
        @battle.save
    
        # Calculations
        @attacker_level = @attacker.level
        @attacker_move_power = attacker_move.power
        @attacker_attack_stat = @attacker.attack
        @defender_defense_stat = @defender.defense
        @type1 = 1
        @type2 = 1
        @random = 1
    
        if @attacker.types.any? { |type| type.id == attacker_move.type_id }
          @STAB = 1.5
        else
          @STAB = 1
        end
    
        damage_calculation
  
        @defender.current_health_point -= @damage_points
        
        winner_checker
        
        if @defender.current_health_point < 0
          @defender.current_health_point = 0
        end
  
        @defender.save
        redirect_to battle_path
      end
    end
  end


  private
  # Use callbacks to share common setup or constrains between actions.
  def set_battle
    @battle = Battle.find(params[:id])
    @damage_points = 0

    set_pokemons_on_battle
  end

  def set_pokemons_on_battle
    @pokemons = @battle.pokemons

    @pokemon1 = @pokemons.order(:created_at).first
    @pokemon2 = @pokemons.order(created_at: :desc).first

    @pokemon1_types = @pokemon1.types
    @pokemon2_types = @pokemon2.types

    @pokemon1_moves = @pokemon1.moves
    @pokemon2_moves = @pokemon2.moves

    @pokemon1_moves_pokemons = @pokemon1.moves_pokemons
    @pokemon2_moves_pokemons = @pokemon2.moves_pokemons
  end

  def damage_calculation
    @step1 = 2 * @attacker_level / 5 + 2
    @step2 = @step1 * @attacker_move_power * @attacker_attack_stat / @defender_defense_stat
    @step3 = @step2 / 50 + 2
    @step4 = @step3 * @STAB * @type1 * @type2

    if @step4 != 1
      random_generator

      @step5 = @step4 * @random / 255
    else
      @step5 = @step4 * @random
    end

    @damage_points = @step5.floor
  end

  def random_generator
    random_generator = Random.new
    @random = random_generator.rand(217..255)
  end

  def winner_checker
    if is_defender_hp_zero
      attacker_battles_pokemon = @attacker.battles_pokemons.where(battle_id: @battle.id)[0]
      attacker_battles_pokemon.winning_status = "Winner"

      defender_battles_pokemon = @defender.battles_pokemons.where(battle_id: @battle.id)[0]
      defender_battles_pokemon.winning_status = "Loser"

      attacker_battles_pokemon.save
      defender_battles_pokemon.save
      
      set_completed_to_battle_status

      level_up_checker
      # learn_move
    elsif is_attacker_moves_pp_equal_to_zero
      attacker_battles_pokemon = @attacker.battles_pokemons.where(battle_id: @battle.id)[0]
      attacker_battles_pokemon.winning_status = "Loser"

      defender_battles_pokemon = @defender.battles_pokemons.where(battle_id: @battle.id)[0]
      defender_battles_pokemon.winning_status = "Winner"

      attacker_battles_pokemon.save
      defender_battles_pokemon.save
      
      set_completed_to_battle_status

      level_up_checker
      # learn_move
    end
  end

  def is_defender_hp_zero
    return @defender.current_health_point <= 0
  end

  def is_attacker_moves_pp_equal_to_zero
    attacker_moves_count = @attacker.moves.count
    attacker_moves_with_zero_pp = 0

    @attacker.moves_pokemons.each do |move|
      if move.current_power_points <= 0
        attacker_moves_with_zero_pp += 1
      end
    end

    return attacker_moves_with_zero_pp == attacker_moves_count
  end

  def set_completed_to_battle_status
    @battle.status = "Completed"
    @battle.save
  end

  def exp_calculation
    gained_exp = @defender.base_exp * @defender.level / 7
  end
  
  def level_up_checker
    level_up_count = 0

    exp_calculation
    
    if @attacker.current_exp + gained_exp == @attacker.base_exp
      @attacker.current_exp = 0
      
      level_up_count = 1
    elsif @attacker.current_exp + gained_exp > @attacker.base_exp
      @attacker.current_exp += gained_exp

      level_up_count = @attacker.current_exp / @attacker.base_exp
      level_up_count = level_up_count.floor

      @attacker.current_exp %= @attacker.base_exp
    elsif @attacker.current_exp + gained_exp < @attacker.base_exp
      @attacker.current_exp += gained_exp
    end

    @attacker.level += level_up_count

    @attacker.save
  end

  def learn_move
    # BELUM
  end

  # Only allow a list of trusted parameters through.
  def battle_params
    params.require(:battle).permit(:pokemon_ids)
  end
end