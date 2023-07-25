class BattlesController < ApplicationController
  # GET /battles
  def index
    @battles = Battle.order(updated_at: :desc)
  end

  # GET /battles/:battle_id/show
  def show
    set_battle
    
    @pokemon_turn = @battle.turn.even? ? "#{@pokemon2.name}'s turn" : "#{@pokemon1.name}'s turn"
    
    if @battle.status == "Completed"
      @winner = @battle.pokemon_1_winning_status == "Winner" ? @pokemon1 : @pokemon2
      @gained_exp = @battle.winner_gained_exp
    end
  end

  # GET /battles/new
  def new
    @battle = Battle.new

    # BELUM ADA VALIDASI PP > 0 HP > 0
    
    # pokemon_ids_battles = Battle.pluck(:pokemon_1_id, :pokemon_2_id).flatten.compact.uniq
    pokemon_ids_in_complete_battles = Battle.where(status: "Completed").pluck(:pokemon_1_id, :pokemon_2_id).flatten.compact.uniq
    # @available_pokemons = Pokemon.where.not(id: pokemon_ids_battles).or(Pokemon.where(id: pokemon_ids_in_complete_battles))
    @available_pokemons = Pokemon.left_outer_joins(:battles_pokemon_1, :battles_pokemon_2).where(battles: { id: nil }).or(Pokemon.where(id: pokemon_ids_in_complete_battles)).compact.uniq
    # p fohta
  end

  
  # POST /battles
  def create
    @battle = Battle.new(battle_params)
    pokemon_1_id = params[:battle][:pokemon_1_id]
    pokemon_2_id = params[:battle][:pokemon_2_id]
    
    if pokemon_1_id.nil? && pokemon_2_id.nil? || pokemon_1_id == pokemon_2_id
      flash[:danger] = "You must select 2 different Pokémons to create a battle!"
      redirect_to new_battle_path
    else
      is_death = false
      is_unable_to_move = false
      is_registered_in_another_battle = false

      @battle.pokemon_1_id = pokemon_1_id
      @battle.pokemon_2_id = pokemon_2_id
      pokemon_1 = @battle.pokemon_1
      pokemon_2 = @battle.pokemon_2
      
      if pokemon_1.current_health_point < 1 || pokemon_2.current_health_point < 1
        is_death = true
      end
      
      pokemon_1.moves_pokemons.each do |move|
        if move.current_power_points < 1
          is_unable_to_move = true
        end
      end
      
      pokemon_2.moves_pokemons.each do |move|
        if move.current_power_points < 1
          is_unable_to_move = true
        end
      end

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
          @battle.pokemon_1_level = @battle.pokemon_1.level
          @battle.pokemon_2_level = @battle.pokemon_2.level
      
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
      @battle.turn += 1
      @battle.status = @battle.turn > 0 ? "In Progress" : "Not Started"
      
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
        attacker_elements = []
        attacker_elements << @attacker.element_1
        attacker_elements << @attacker.element_2

        @attacker_level = @attacker.level
        @attacker_move_power = attacker_move.power
        @attacker_attack_stat = @attacker.attack
        @defender_defense_stat = @defender.defense
        @type1 = 1
        @type2 = 1
        @random = 1

        level_up_count = 0
    
        # if @attacker.types.any? { |type| type.id == attacker_move.type_id }
        if attacker_elements.any? { |element| element.id == attacker_move.element.id }
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

        if level_up_count > 0
          redirect_to pokemon_learn_moves_path(level_up_count: level_up_count)
        else
          redirect_to battle_path
        end
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
    # @pokemons = @battle.pokemons

    @pokemon1 = @battle.pokemon_1
    @pokemon2 = @battle.pokemon_2

    # @pokemon1_types = @pokemon1.types
    # @pokemon2_types = @pokemon2.types

    @pokemon1_element_1 = @pokemon1.element_1
    @pokemon1_element_2 = @pokemon1.element_2
    @pokemon2_element_1 = @pokemon2.element_1
    @pokemon2_element_2 = @pokemon2.element_2

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
      # attacker_battles_pokemon = @attacker.battles_pokemons.where(battle_id: @battle.id)[0]
      # attacker_battles_pokemon.winning_status = "Winner"

      # defender_battles_pokemon = @defender.battles_pokemons.where(battle_id: @battle.id)[0]
      # defender_battles_pokemon.winning_status = "Loser"

      if @attacker.id == @pokemon1.id
        @battle.pokemon_1_winning_status = "Winner"
        @battle.pokemon_2_winning_status = "Loser"

        @winner = @pokemon1
        @loser = @pokemon2
      elsif @attacker.id == @pokemon2.id
        @battle.pokemon_1_winning_status = "Loser"
        @battle.pokemon_2_winning_status = "Winner"
        
        @winner = @pokemon2
        @loser = @pokemon1
      end
      
      save_health_point_to_battle_stat
      set_completed_to_battle_status
      level_up_checker
      
      @battle.save
    elsif is_attacker_moves_pp_equal_to_zero
      # attacker_battles_pokemon = @attacker.battles_pokemons.where(battle_id: @battle.id)[0]
      # attacker_battles_pokemon.winning_status = "Loser"

      # defender_battles_pokemon = @defender.battles_pokemons.where(battle_id: @battle.id)[0]
      # defender_battles_pokemon.winning_status = "Winner"

      if @attacker.id == @pokemon1.id
        @battle.pokemon_1_winning_status = "Loser"
        @battle.pokemon_2_winning_status = "Winner"

        @winner = @pokemon2
        @loser = @pokemon1
      elsif @attacker.id == @pokemon2.id
        @battle.pokemon_1_winning_status = "Winner"
        @battle.pokemon_2_winning_status = "Loser"
        
        @winner = @pokemon1
        @loser = @pokemon2
      end
      
      save_health_point_to_battle_stat
      set_completed_to_battle_status
      level_up_checker
      
      @battle.save
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
    # @battle.save
  end

  def save_health_point_to_battle_stat
    @battle.pokemon_1_health_point = "#{@pokemon1.current_health_point}/#{@pokemon1.max_health_point}"
    @battle.pokemon_2_health_point = "#{@pokemon2.current_health_point}/#{@pokemon2.max_health_point}"
  end

  def exp_calculation
    @gained_exp = @loser.base_exp * @loser.level / 7
  end
  
  def level_up_checker
    level_up_count = 0
    exp_calculation

    @battle.winner_exp_before = "#{@winner.current_exp}/#{@winner.base_exp}"
    
    if @winner.current_exp + @gained_exp == @winner.base_exp
      @winner.current_exp = 0
      
      level_up_count = 1
    elsif @winner.current_exp + @gained_exp > @winner.base_exp
      @winner.current_exp += @gained_exp

      level_up_count = @winner.current_exp / @winner.base_exp
      level_up_count = level_up_count.floor

      @winner.current_exp %= @winner.base_exp
    elsif @winner.current_exp + @gained_exp < @winner.base_exp
      @winner.current_exp += @gained_exp
    end

    @winner.level += level_up_count

    @winner.save

    @battle.winner_gained_exp = @gained_exp
    @battle.winner_level_up_count = level_up_count

    @battle.save
  end

  def learn_move
    # BELUM
  end

  # Only allow a list of trusted parameters through.
  def battle_params
    params.require(:battle).permit(:pokemon_1_id, :pokemon_2_id)
  end
end