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
    
    all_pokemons = Pokemon.all
    all_pokemon_ids = all_pokemons.pluck(:id)
    pokemon_ids_in_ongoing_battles = Battle.where(status: ["Not Started", "In Progress"]).pluck(:pokemon_1_id, :pokemon_2_id).flatten.compact.uniq
    pokemon_ids_with_hp_zero_or_less = Pokemon.where("current_health_point <= ?", 0).pluck(:id)
    pokemon_ids_with_pp_zero_or_less = MovesPokemon.where("current_power_points <= ?", 0).pluck(:pokemon_id)

    available_pokemons_ids = all_pokemon_ids - pokemon_ids_in_ongoing_battles - pokemon_ids_with_hp_zero_or_less - pokemon_ids_with_pp_zero_or_less
    @available_pokemons = Pokemon.find(available_pokemons_ids).sort_by { |pokemon| pokemon.name }

    # p "==================================="
    # p "all_pokemon_ids: #{all_pokemon_ids}"
    # p "pokemon_ids_in_ongoing_battles: #{pokemon_ids_in_ongoing_battles}"
    # p "pokemon_ids_with_hp_zero_or_less: #{pokemon_ids_with_hp_zero_or_less}"
    # p "pokemon_ids_with_pp_zero_or_less: #{pokemon_ids_with_pp_zero_or_less}"
    # p "++++++++++"
    # p "available_pokemons_ids: #{available_pokemons_ids}"
    # p "@available_pokemons: #{@available_pokemons}"
    # p "==================================="
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
            redirect_to battle_path(@battle)
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


    # Validasi completed battle
    if @battle.status == "Completed"
      flash[:danger] = "The battle is completed. You can't use all of moves again!"
      redirect_to battle_path
    else
      # @attacker = Pokemon.find(params[:attacker_id])
      # @defender = Pokemon.find(params[:defender_id])
      update_all_data_from_db
      
      p "======================================================="
      p "======================================================="
      p "======================================================="
      p "MOVE #{@battle.turn} START"
      p "+++++++++++"
      p "==================="
      p "+++++++++++"
      p "BATTLE"
      p "@battle.turn: #{@battle.turn}"
      p "@battle.pokemon_1_id: #{@battle.pokemon_1_id}"
      p "@battle.pokemon_1_health_point: #{@battle.pokemon_1_health_point}"
      p "@battle.pokemon_1_level: #{@battle.pokemon_1_level}"
      p "+++++++++++"
      p "@battle.pokemon_2_id: #{@battle.pokemon_2_id}"
      p "@battle.pokemon_2_health_point: #{@battle.pokemon_2_health_point}"
      p "@battle.pokemon_2_level: #{@battle.pokemon_2_level}"
      p "+++++++++++"
      p "@battle.winner_gained_exp: #{@battle.winner_gained_exp}"
      p "@battle.winner_level_up_count: #{@battle.winner_level_up_count}"
      p "@battle.winner_exp_before: #{@battle.winner_exp_before}"
      p "+++++++++++"
      p "==================="
      p "+++++++++++"
      p "POKEMON"
      p "@pokemon1.id: #{@pokemon1.id}"
      p "@pokemon1.name: #{@pokemon1.name}"
      p "@pokemon1.current_health_point: #{@pokemon1.current_health_point}"
      p "@pokemon1.level: #{@pokemon1.level}"
      p "@pokemon1.current_exp: #{@pokemon1.current_exp}"
      p "+++++++++++"
      p "@pokemon2.id: #{@pokemon2.id}"
      p "@pokemon2.name: #{@pokemon2.name}"
      p "@pokemon2.current_health_point: #{@pokemon2.current_health_point}"
      p "@pokemon2.level: #{@pokemon2.level}"
      p "@pokemon2.current_exp: #{@pokemon2.current_exp}"
      p "+++++++++++"
      p "==================="
      p "+++++++++++"
      p "ATTACKER & DEFENDER"
      p "@attacker.id: #{@attacker.id}"
      p "@attacker.name: #{@attacker.name}"
      p "@attacker.current_health_point: #{@attacker.current_health_point}"
      p "@attacker.level: #{@attacker.level}"
      p "@attacker.current_exp: #{@attacker.current_exp}"
      p "+++++++++++"
      p "@defender.id: #{@defender.id}"
      p "@defender.name: #{@defender.name}"
      p "@defender.current_health_point: #{@defender.current_health_point}"
      p "@defender.level: #{@defender.level}"
      p "@defender.current_exp: #{@defender.current_exp}"
      p "+++++++++++"
      p "==================="
      p "+++++++++++"
      p "MOVE #{@battle.turn} START"
      p "======================================================="
      p "======================================================="
      p "======================================================="

      @pokemon_turn = @battle.turn.even? ? "#{@pokemon2.name}'s turn" : "#{@pokemon1.name}'s turn"

      # Validasi pokemon turn
      if @battle.turn.even? && @attacker.id != @pokemon2.id
        p "======================================================="
        p "======================================================="
        p "======================================================="
        p "MOVE #{@battle.turn} END"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "BATTLE"
        p "@battle.turn: #{@battle.turn}"
        p "@battle.pokemon_1_id: #{@battle.pokemon_1_id}"
        p "@battle.pokemon_1_health_point: #{@battle.pokemon_1_health_point}"
        p "@battle.pokemon_1_level: #{@battle.pokemon_1_level}"
        p "+++++++++++"
        p "@battle.pokemon_2_id: #{@battle.pokemon_2_id}"
        p "@battle.pokemon_2_health_point: #{@battle.pokemon_2_health_point}"
        p "@battle.pokemon_2_level: #{@battle.pokemon_2_level}"
        p "+++++++++++"
        p "@battle.winner_gained_exp: #{@battle.winner_gained_exp}"
        p "@battle.winner_level_up_count: #{@battle.winner_level_up_count}"
        p "@battle.winner_exp_before: #{@battle.winner_exp_before}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "POKEMON"
        p "@pokemon1.id: #{@pokemon1.id}"
        p "@pokemon1.name: #{@pokemon1.name}"
        p "@pokemon1.current_health_point: #{@pokemon1.current_health_point}"
        p "@pokemon1.level: #{@pokemon1.level}"
        p "@pokemon1.current_exp: #{@pokemon1.current_exp}"
        p "+++++++++++"
        p "@pokemon2.id: #{@pokemon2.id}"
        p "@pokemon2.name: #{@pokemon2.name}"
        p "@pokemon2.current_health_point: #{@pokemon2.current_health_point}"
        p "@pokemon2.level: #{@pokemon2.level}"
        p "@pokemon2.current_exp: #{@pokemon2.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "ATTACKER & DEFENDER"
        p "@attacker.id: #{@attacker.id}"
        p "@attacker.name: #{@attacker.name}"
        p "@attacker.current_health_point: #{@attacker.current_health_point}"
        p "@attacker.level: #{@attacker.level}"
        p "@attacker.current_exp: #{@attacker.current_exp}"
        p "+++++++++++"
        p "@defender.id: #{@defender.id}"
        p "@defender.name: #{@defender.name}"
        p "@defender.current_health_point: #{@defender.current_health_point}"
        p "@defender.level: #{@defender.level}"
        p "@defender.current_exp: #{@defender.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "MOVE #{@battle.turn} END"
        p "======================================================="
        p "======================================================="
        p "======================================================="

        flash[:danger] = "Please follow the rules regarding turns!"
        redirect_to battle_path
        
        return
      end

      if !@battle.turn.even? && @attacker.id != @pokemon1.id
        p "======================================================="
        p "======================================================="
        p "======================================================="
        p "MOVE #{@battle.turn} END"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "BATTLE"
        p "@battle.turn: #{@battle.turn}"
        p "@battle.pokemon_1_id: #{@battle.pokemon_1_id}"
        p "@battle.pokemon_1_health_point: #{@battle.pokemon_1_health_point}"
        p "@battle.pokemon_1_level: #{@battle.pokemon_1_level}"
        p "+++++++++++"
        p "@battle.pokemon_2_id: #{@battle.pokemon_2_id}"
        p "@battle.pokemon_2_health_point: #{@battle.pokemon_2_health_point}"
        p "@battle.pokemon_2_level: #{@battle.pokemon_2_level}"
        p "+++++++++++"
        p "@battle.winner_gained_exp: #{@battle.winner_gained_exp}"
        p "@battle.winner_level_up_count: #{@battle.winner_level_up_count}"
        p "@battle.winner_exp_before: #{@battle.winner_exp_before}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "POKEMON"
        p "@pokemon1.id: #{@pokemon1.id}"
        p "@pokemon1.name: #{@pokemon1.name}"
        p "@pokemon1.current_health_point: #{@pokemon1.current_health_point}"
        p "@pokemon1.level: #{@pokemon1.level}"
        p "@pokemon1.current_exp: #{@pokemon1.current_exp}"
        p "+++++++++++"
        p "@pokemon2.id: #{@pokemon2.id}"
        p "@pokemon2.name: #{@pokemon2.name}"
        p "@pokemon2.current_health_point: #{@pokemon2.current_health_point}"
        p "@pokemon2.level: #{@pokemon2.level}"
        p "@pokemon2.current_exp: #{@pokemon2.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "ATTACKER & DEFENDER"
        p "@attacker.id: #{@attacker.id}"
        p "@attacker.name: #{@attacker.name}"
        p "@attacker.current_health_point: #{@attacker.current_health_point}"
        p "@attacker.level: #{@attacker.level}"
        p "@attacker.current_exp: #{@attacker.current_exp}"
        p "+++++++++++"
        p "@defender.id: #{@defender.id}"
        p "@defender.name: #{@defender.name}"
        p "@defender.current_health_point: #{@defender.current_health_point}"
        p "@defender.level: #{@defender.level}"
        p "@defender.current_exp: #{@defender.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "MOVE #{@battle.turn} END"
        p "======================================================="
        p "======================================================="
        p "======================================================="

        # UJUNG

        flash[:danger] = "Please follow the rules regarding turns!"
        redirect_to battle_path

        return
      end
      
      # Move
      is_unable_to_move = false

      # attacker_moves_pokemon = MovesPokemon.find(params[:attacker_moves_pokemon_id])
      # attacker_move = attacker_moves_pokemon.move

      p "======================================================="
      p "======================================================="
      p "======================================================="
      p "MOVE #{@battle.turn} INIT"
      p "+++++++++++"
      p "==================="
      p "+++++++++++"
      p "BATTLE"
      p "@battle.turn: #{@battle.turn}"
      p "@battle.pokemon_1_id: #{@battle.pokemon_1_id}"
      p "@battle.pokemon_1_health_point: #{@battle.pokemon_1_health_point}"
      p "@battle.pokemon_1_level: #{@battle.pokemon_1_level}"
      p "+++++++++++"
      p "@battle.pokemon_2_id: #{@battle.pokemon_2_id}"
      p "@battle.pokemon_2_health_point: #{@battle.pokemon_2_health_point}"
      p "@battle.pokemon_2_level: #{@battle.pokemon_2_level}"
      p "+++++++++++"
      p "@battle.winner_gained_exp: #{@battle.winner_gained_exp}"
      p "@battle.winner_level_up_count: #{@battle.winner_level_up_count}"
      p "@battle.winner_exp_before: #{@battle.winner_exp_before}"
      p "+++++++++++"
      p "==================="
      p "+++++++++++"
      p "POKEMON"
      p "@pokemon1.id: #{@pokemon1.id}"
      p "@pokemon1.name: #{@pokemon1.name}"
      p "@pokemon1.current_health_point: #{@pokemon1.current_health_point}"
      p "@pokemon1.level: #{@pokemon1.level}"
      p "@pokemon1.current_exp: #{@pokemon1.current_exp}"
      p "+++++++++++"
      p "@pokemon2.id: #{@pokemon2.id}"
      p "@pokemon2.name: #{@pokemon2.name}"
      p "@pokemon2.current_health_point: #{@pokemon2.current_health_point}"
      p "@pokemon2.level: #{@pokemon2.level}"
      p "@pokemon2.current_exp: #{@pokemon2.current_exp}"
      p "+++++++++++"
      p "==================="
      p "+++++++++++"
      p "ATTACKER & DEFENDER"
      p "@attacker.id: #{@attacker.id}"
      p "@attacker.name: #{@attacker.name}"
      p "@attacker.current_health_point: #{@attacker.current_health_point}"
      p "@attacker.level: #{@attacker.level}"
      p "@attacker.current_exp: #{@attacker.current_exp}"
      p "+++++++++++"
      p "@defender.id: #{@defender.id}"
      p "@defender.name: #{@defender.name}"
      p "@defender.current_health_point: #{@defender.current_health_point}"
      p "@defender.level: #{@defender.level}"
      p "@defender.current_exp: #{@defender.current_exp}"
      p "+++++++++++"
      p "==================="
      p "+++++++++++"
      p "MOVE #{@battle.turn} INIT"
      p "======================================================="
      p "======================================================="
      p "======================================================="

      update_all_data_from_db
  
      # Validasi PP dari move yang dilakukan
      if @attacker_moves_pokemon.current_power_points <= 0
        # Jika PP <= 0
        @attacker_moves_pokemon.current_power_points = 0
        @attacker_moves_pokemon.save

        update_all_data_from_db

        p "======================================================="
        p "======================================================="
        p "======================================================="
        p "MOVE #{@battle.turn} VALIDASI PP <= 0"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "BATTLE"
        p "@battle.turn: #{@battle.turn}"
        p "@battle.pokemon_1_id: #{@battle.pokemon_1_id}"
        p "@battle.pokemon_1_health_point: #{@battle.pokemon_1_health_point}"
        p "@battle.pokemon_1_level: #{@battle.pokemon_1_level}"
        p "+++++++++++"
        p "@battle.pokemon_2_id: #{@battle.pokemon_2_id}"
        p "@battle.pokemon_2_health_point: #{@battle.pokemon_2_health_point}"
        p "@battle.pokemon_2_level: #{@battle.pokemon_2_level}"
        p "+++++++++++"
        p "@battle.winner_gained_exp: #{@battle.winner_gained_exp}"
        p "@battle.winner_level_up_count: #{@battle.winner_level_up_count}"
        p "@battle.winner_exp_before: #{@battle.winner_exp_before}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "POKEMON"
        p "@pokemon1.id: #{@pokemon1.id}"
        p "@pokemon1.name: #{@pokemon1.name}"
        p "@pokemon1.current_health_point: #{@pokemon1.current_health_point}"
        p "@pokemon1.level: #{@pokemon1.level}"
        p "@pokemon1.current_exp: #{@pokemon1.current_exp}"
        p "+++++++++++"
        p "@pokemon2.id: #{@pokemon2.id}"
        p "@pokemon2.name: #{@pokemon2.name}"
        p "@pokemon2.current_health_point: #{@pokemon2.current_health_point}"
        p "@pokemon2.level: #{@pokemon2.level}"
        p "@pokemon2.current_exp: #{@pokemon2.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "ATTACKER & DEFENDER"
        p "@attacker.id: #{@attacker.id}"
        p "@attacker.name: #{@attacker.name}"
        p "@attacker.current_health_point: #{@attacker.current_health_point}"
        p "@attacker.level: #{@attacker.level}"
        p "@attacker.current_exp: #{@attacker.current_exp}"
        p "+++++++++++"
        p "@defender.id: #{@defender.id}"
        p "@defender.name: #{@defender.name}"
        p "@defender.current_health_point: #{@defender.current_health_point}"
        p "@defender.level: #{@defender.level}"
        p "@defender.current_exp: #{@defender.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "MOVE #{@battle.turn} VALIDASI PP <= 0"
        p "======================================================="
        p "======================================================="
        p "======================================================="

        # UJUNG
  
        flash[:danger] = "Can't use a move with 0 power points!"
        redirect_to battle_path
      else
        # Jika PP > 0, lanjut kalkulasi move

        update_all_data_from_db

        p "======================================================="
        p "======================================================="
        p "======================================================="
        p "MOVE #{@battle.turn} VALIDASI PP > 0"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "BATTLE"
        p "@battle.turn: #{@battle.turn}"
        p "@battle.pokemon_1_id: #{@battle.pokemon_1_id}"
        p "@battle.pokemon_1_health_point: #{@battle.pokemon_1_health_point}"
        p "@battle.pokemon_1_level: #{@battle.pokemon_1_level}"
        p "+++++++++++"
        p "@battle.pokemon_2_id: #{@battle.pokemon_2_id}"
        p "@battle.pokemon_2_health_point: #{@battle.pokemon_2_health_point}"
        p "@battle.pokemon_2_level: #{@battle.pokemon_2_level}"
        p "+++++++++++"
        p "@battle.winner_gained_exp: #{@battle.winner_gained_exp}"
        p "@battle.winner_level_up_count: #{@battle.winner_level_up_count}"
        p "@battle.winner_exp_before: #{@battle.winner_exp_before}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "POKEMON"
        p "@pokemon1.id: #{@pokemon1.id}"
        p "@pokemon1.name: #{@pokemon1.name}"
        p "@pokemon1.current_health_point: #{@pokemon1.current_health_point}"
        p "@pokemon1.level: #{@pokemon1.level}"
        p "@pokemon1.current_exp: #{@pokemon1.current_exp}"
        p "+++++++++++"
        p "@pokemon2.id: #{@pokemon2.id}"
        p "@pokemon2.name: #{@pokemon2.name}"
        p "@pokemon2.current_health_point: #{@pokemon2.current_health_point}"
        p "@pokemon2.level: #{@pokemon2.level}"
        p "@pokemon2.current_exp: #{@pokemon2.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "ATTACKER & DEFENDER"
        p "@attacker.id: #{@attacker.id}"
        p "@attacker.name: #{@attacker.name}"
        p "@attacker.current_health_point: #{@attacker.current_health_point}"
        p "@attacker.level: #{@attacker.level}"
        p "@attacker.current_exp: #{@attacker.current_exp}"
        p "+++++++++++"
        p "@defender.id: #{@defender.id}"
        p "@defender.name: #{@defender.name}"
        p "@defender.current_health_point: #{@defender.current_health_point}"
        p "@defender.level: #{@defender.level}"
        p "@defender.current_exp: #{@defender.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "MOVE #{@battle.turn} VALIDASI PP > 0"
        p "======================================================="
        p "======================================================="
        p "======================================================="
        
        @attacker_moves_pokemon.current_power_points -= 1
        @attacker_moves_pokemon.save

        update_all_data_from_db

        # Turn
        @battle.turn += 1
        @battle.status = @battle.turn > 0 ? "In Progress" : "Not Started"
        @battle.save

        update_all_data_from_db
    
        # Calculations
        attacker_elements = []
        attacker_elements << @attacker.element_1
        attacker_elements << @attacker.element_2

        @attacker_level = @attacker.level
        @attacker_move_power = @attacker_move.power
        @attacker_attack_stat = @attacker.attack
        @defender_defense_stat = @defender.defense
        @type1 = 1
        @type2 = 1
        @random = 1

        @level_up_count = 0
    
        if attacker_elements.any? { |element| element.id == @attacker_move.element.id }
          @STAB = 1.5
        else
          @STAB = 1
        end
    
        @damage_points = damage_calculation

        p "======================================================="
        p "======================================================="
        p "======================================================="
        p "MOVE #{@battle.turn} SEBELUM KALKULASI HP"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "BATTLE"
        p "@battle.turn: #{@battle.turn}"
        p "@battle.pokemon_1_id: #{@battle.pokemon_1_id}"
        p "@battle.pokemon_1_health_point: #{@battle.pokemon_1_health_point}"
        p "@battle.pokemon_1_level: #{@battle.pokemon_1_level}"
        p "+++++++++++"
        p "@battle.pokemon_2_id: #{@battle.pokemon_2_id}"
        p "@battle.pokemon_2_health_point: #{@battle.pokemon_2_health_point}"
        p "@battle.pokemon_2_level: #{@battle.pokemon_2_level}"
        p "+++++++++++"
        p "@battle.winner_gained_exp: #{@battle.winner_gained_exp}"
        p "@battle.winner_level_up_count: #{@battle.winner_level_up_count}"
        p "@battle.winner_exp_before: #{@battle.winner_exp_before}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "POKEMON"
        p "@pokemon1.id: #{@pokemon1.id}"
        p "@pokemon1.name: #{@pokemon1.name}"
        p "@pokemon1.current_health_point: #{@pokemon1.current_health_point}"
        p "@pokemon1.level: #{@pokemon1.level}"
        p "@pokemon1.current_exp: #{@pokemon1.current_exp}"
        p "+++++++++++"
        p "@pokemon2.id: #{@pokemon2.id}"
        p "@pokemon2.name: #{@pokemon2.name}"
        p "@pokemon2.current_health_point: #{@pokemon2.current_health_point}"
        p "@pokemon2.level: #{@pokemon2.level}"
        p "@pokemon2.current_exp: #{@pokemon2.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "ATTACKER & DEFENDER"
        p "@attacker.id: #{@attacker.id}"
        p "@attacker.name: #{@attacker.name}"
        p "@attacker.current_health_point: #{@attacker.current_health_point}"
        p "@attacker.level: #{@attacker.level}"
        p "@attacker.current_exp: #{@attacker.current_exp}"
        p "+++++++++++"
        p "@defender.id: #{@defender.id}"
        p "@defender.name: #{@defender.name}"
        p "@defender.current_health_point: #{@defender.current_health_point}"
        p "@defender.level: #{@defender.level}"
        p "@defender.current_exp: #{@defender.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "MOVE #{@battle.turn} SEBELUM KALKULASI HP"
        p "======================================================="
        p "======================================================="
        p "======================================================="
        
        @defender.current_health_point -= @damage_points
        
        @defender.save
        
        update_all_data_from_db

        p "======================================================="
        p "======================================================="
        p "======================================================="
        p "MOVE #{@battle.turn} SESUDAH KALKULASI HP"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "BATTLE"
        p "@battle.turn: #{@battle.turn}"
        p "@battle.status: #{@battle.status}"
        p "@battle.pokemon_1_id: #{@battle.pokemon_1_id}"
        p "@battle.pokemon_1_health_point: #{@battle.pokemon_1_health_point}"
        p "@battle.pokemon_1_level: #{@battle.pokemon_1_level}"
        p "@battle.pokemon_1_winning_status: #{@battle.pokemon_1_winning_status}"
        p "+++++++++++"
        p "@battle.pokemon_2_id: #{@battle.pokemon_2_id}"
        p "@battle.pokemon_2_health_point: #{@battle.pokemon_2_health_point}"
        p "@battle.pokemon_2_level: #{@battle.pokemon_2_level}"
        p "@battle.pokemon_2_winning_status: #{@battle.pokemon_2_winning_status}"
        p "+++++++++++"
        p "@battle.winner_gained_exp: #{@battle.winner_gained_exp}"
        p "@battle.winner_level_up_count: #{@battle.winner_level_up_count}"
        p "@battle.winner_exp_before: #{@battle.winner_exp_before}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "POKEMON"
        p "@pokemon1.id: #{@pokemon1.id}"
        p "@pokemon1.name: #{@pokemon1.name}"
        p "@pokemon1.current_health_point: #{@pokemon1.current_health_point}"
        p "@pokemon1.level: #{@pokemon1.level}"
        p "@pokemon1.current_exp: #{@pokemon1.current_exp}"
        p "+++++++++++"
        p "@pokemon2.id: #{@pokemon2.id}"
        p "@pokemon2.name: #{@pokemon2.name}"
        p "@pokemon2.current_health_point: #{@pokemon2.current_health_point}"
        p "@pokemon2.level: #{@pokemon2.level}"
        p "@pokemon2.current_exp: #{@pokemon2.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "ATTACKER & DEFENDER"
        p "@attacker.id: #{@attacker.id}"
        p "@attacker.name: #{@attacker.name}"
        p "@attacker.current_health_point: #{@attacker.current_health_point}"
        p "@attacker.level: #{@attacker.level}"
        p "@attacker.current_exp: #{@attacker.current_exp}"
        p "+++++++++++"
        p "@defender.id: #{@defender.id}"
        p "@defender.name: #{@defender.name}"
        p "@defender.current_health_point: #{@defender.current_health_point}"
        p "@defender.level: #{@defender.level}"
        p "@defender.current_exp: #{@defender.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        # p "WINNER & LOSER"
        # p "@winner.id: #{@winner.id}"
        # p "@winner.name: #{@winner.name}"
        # p "@winner.current_health_point: #{@winner.current_health_point}"
        # p "@winner.level: #{@winner.level}"
        # p "@winner.current_exp: #{@winner.current_exp}"
        # p "+++++++++++"
        # p "@loser.id: #{@loser.id}"
        # p "@loser.name: #{@loser.name}"
        # p "@loser.current_health_point: #{@loser.current_health_point}"
        # p "@loser.level: #{@loser.level}"
        # p "@loser.current_exp: #{@loser.current_exp}"
        # p "+++++++++++"
        # p "==================="
        # p "+++++++++++"
        p "MOVE #{@battle.turn} SESUDAH KALKULASI HP"
        p "======================================================="
        p "======================================================="
        p "======================================================="
        
        winner_checker

        update_all_data_from_db

        p "======================================================="
        p "======================================================="
        p "======================================================="
        p "MOVE #{@battle.turn} SESUDAH WINNER CHECKER"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "BATTLE"
        p "@battle.turn: #{@battle.turn}"
        p "@battle.status: #{@battle.status}"
        p "@battle.pokemon_1_id: #{@battle.pokemon_1_id}"
        p "@battle.pokemon_1_health_point: #{@battle.pokemon_1_health_point}"
        p "@battle.pokemon_1_level: #{@battle.pokemon_1_level}"
        p "@battle.pokemon_1_winning_status: #{@battle.pokemon_1_winning_status}"
        p "+++++++++++"
        p "@battle.pokemon_2_id: #{@battle.pokemon_2_id}"
        p "@battle.pokemon_2_health_point: #{@battle.pokemon_2_health_point}"
        p "@battle.pokemon_2_level: #{@battle.pokemon_2_level}"
        p "@battle.pokemon_2_winning_status: #{@battle.pokemon_2_winning_status}"
        p "+++++++++++"
        p "@battle.winner_gained_exp: #{@battle.winner_gained_exp}"
        p "@battle.winner_level_up_count: #{@battle.winner_level_up_count}"
        p "@battle.winner_exp_before: #{@battle.winner_exp_before}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "POKEMON"
        p "@pokemon1.id: #{@pokemon1.id}"
        p "@pokemon1.name: #{@pokemon1.name}"
        p "@pokemon1.current_health_point: #{@pokemon1.current_health_point}"
        p "@pokemon1.level: #{@pokemon1.level}"
        p "@pokemon1.current_exp: #{@pokemon1.current_exp}"
        p "+++++++++++"
        p "@pokemon2.id: #{@pokemon2.id}"
        p "@pokemon2.name: #{@pokemon2.name}"
        p "@pokemon2.current_health_point: #{@pokemon2.current_health_point}"
        p "@pokemon2.level: #{@pokemon2.level}"
        p "@pokemon2.current_exp: #{@pokemon2.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        p "ATTACKER & DEFENDER"
        p "@attacker.id: #{@attacker.id}"
        p "@attacker.name: #{@attacker.name}"
        p "@attacker.current_health_point: #{@attacker.current_health_point}"
        p "@attacker.level: #{@attacker.level}"
        p "@attacker.current_exp: #{@attacker.current_exp}"
        p "+++++++++++"
        p "@defender.id: #{@defender.id}"
        p "@defender.name: #{@defender.name}"
        p "@defender.current_health_point: #{@defender.current_health_point}"
        p "@defender.level: #{@defender.level}"
        p "@defender.current_exp: #{@defender.current_exp}"
        p "+++++++++++"
        p "==================="
        p "+++++++++++"
        if !@winner.nil? && !@loser.nil?
          p "WINNER & LOSER"
          p "@winner.id: #{@winner.id}"
          p "@winner.name: #{@winner.name}"
          p "@winner.current_health_point: #{@winner.current_health_point}"
          p "@winner.level: #{@winner.level}"
          p "@winner.current_exp: #{@winner.current_exp}"
          p "+++++++++++"
          p "@loser.id: #{@loser.id}"
          p "@loser.name: #{@loser.name}"
          p "@loser.current_health_point: #{@loser.current_health_point}"
          p "@loser.level: #{@loser.level}"
          p "@loser.current_exp: #{@loser.current_exp}"
          p "+++++++++++"
          p "==================="
          p "+++++++++++"
        end
        p "MOVE #{@battle.turn} SESUDAH WINNER CHECKER"
        p "======================================================="
        p "======================================================="
        p "======================================================="

        # if @defender.current_health_point < 0
        #   @defender.current_health_point = 0
        # end

        # @defender.save
        # update_all_data_from_db

        # p "======================================================="
        # p "======================================================="
        # p "======================================================="
        # p "MOVE #{@battle.turn} SESUDAH UPDATE DATA BATTLE"
        # p "+++++++++++"
        # p "==================="
        # p "+++++++++++"
        # p "BATTLE"
        # p "@battle.turn: #{@battle.turn}"
        # p "@battle.status: #{@battle.status}"
        # p "@battle.pokemon_1_id: #{@battle.pokemon_1_id}"
        # p "@battle.pokemon_1_health_point: #{@battle.pokemon_1_health_point}"
        # p "@battle.pokemon_1_level: #{@battle.pokemon_1_level}"
        # p "+++++++++++"
        # p "@battle.pokemon_2_id: #{@battle.pokemon_2_id}"
        # p "@battle.pokemon_2_health_point: #{@battle.pokemon_2_health_point}"
        # p "@battle.pokemon_2_level: #{@battle.pokemon_2_level}"
        # p "+++++++++++"
        # p "@battle.winner_gained_exp: #{@battle.winner_gained_exp}"
        # p "@battle.winner_level_up_count: #{@battle.winner_level_up_count}"
        # p "@battle.winner_exp_before: #{@battle.winner_exp_before}"
        # p "+++++++++++"
        # p "==================="
        # p "+++++++++++"
        # p "POKEMON"
        # p "@pokemon1.id: #{@pokemon1.id}"
        # p "@pokemon1.name: #{@pokemon1.name}"
        # p "@pokemon1.current_health_point: #{@pokemon1.current_health_point}"
        # p "@pokemon1.level: #{@pokemon1.level}"
        # p "@pokemon1.current_exp: #{@pokemon1.current_exp}"
        # p "+++++++++++"
        # p "@pokemon2.id: #{@pokemon2.id}"
        # p "@pokemon2.name: #{@pokemon2.name}"
        # p "@pokemon2.current_health_point: #{@pokemon2.current_health_point}"
        # p "@pokemon2.level: #{@pokemon2.level}"
        # p "@pokemon2.current_exp: #{@pokemon2.current_exp}"
        # p "+++++++++++"
        # p "==================="
        # p "+++++++++++"
        # p "ATTACKER & DEFENDER"
        # p "@attacker.id: #{@attacker.id}"
        # p "@attacker.name: #{@attacker.name}"
        # p "@attacker.current_health_point: #{@attacker.current_health_point}"
        # p "@attacker.level: #{@attacker.level}"
        # p "@attacker.current_exp: #{@attacker.current_exp}"
        # p "+++++++++++"
        # p "@defender.id: #{@defender.id}"
        # p "@defender.name: #{@defender.name}"
        # p "@defender.current_health_point: #{@defender.current_health_point}"
        # p "@defender.level: #{@defender.level}"
        # p "@defender.current_exp: #{@defender.current_exp}"
        # p "+++++++++++"
        # p "==================="
        # p "+++++++++++"
        # p "MOVE #{@battle.turn} SESUDAH UPDATE DATA BATTLE"
        # p "======================================================="
        # p "======================================================="
        # p "======================================================="
        
        # Jika battle selesai
        if @battle.status == "Completed"
          update_all_data_from_db
          level_up_checker

          p "\n==============================="
          p "@level_up_count: #{@level_up_count}"
          p "free_move_space: #{free_move_space}"
          p "learn_move_quota: #{learn_move_quota}"
          p "===============================\n"
          
          # Jika dapat learn move
          if learn_move_quota > 0
            # Jika ada slot kosong
            if learn_move_quota <= free_move_space && @winner.moves.count <= 4
              learn_move_auto_fill

              update_all_data_from_db
              save_health_point_to_battle_stat
              redirect_to battle_path
            elsif learn_move_quota > free_move_space && @winner.moves.count == 4
              # handling ada slot tapi ada sisa buat manual
              quota = learn_move_quota
              quota -= free_move_space

              update_all_data_from_db
              save_health_point_to_battle_stat
              redirect_to pokemon_learn_moves_path(
                @winner, 
                level_up_count: @level_up_count, 
                free_move_space: free_move_space,
                learn_move_quota: quota,
              )
            end
          else
            update_all_data_from_db
            save_health_point_to_battle_stat
            redirect_to battle_path
          end
        else
          update_all_data_from_db
          save_health_point_to_battle_stat
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
    @pokemon1 = @battle.pokemon_1
    @pokemon2 = @battle.pokemon_2

    @pokemon1_element_1 = @pokemon1.element_1
    @pokemon1_element_2 = @pokemon1.element_2
    @pokemon2_element_1 = @pokemon2.element_1
    @pokemon2_element_2 = @pokemon2.element_2

    @pokemon1_moves = @pokemon1.moves
    @pokemon2_moves = @pokemon2.moves

    @pokemon1_moves_pokemons = @pokemon1.moves_pokemons
    @pokemon2_moves_pokemons = @pokemon2.moves_pokemons
  end

  def set_attacker_defender
    @attacker = Pokemon.find(params[:attacker_id])
    @defender = Pokemon.find(params[:defender_id])

    @attacker_moves_pokemon = MovesPokemon.find(params[:attacker_moves_pokemon_id])
    @attacker_move = @attacker_moves_pokemon.move
  end

  def set_winner_loser

  end

  def update_all_data_from_db
    set_battle
    set_attacker_defender
  end

  def damage_calculation
    @step1 = 2 * @attacker_level / 5 + 2
    @step2 = @step1 * @attacker_move_power * @attacker_attack_stat / @defender_defense_stat
    @step3 = @step2 / 50 + 2
    @step4 = @step3 * @STAB * @type1 * @type2

    if @step4 != 1
      @random = random_generator

      @step5 = @step4 * @random / 255
    else
      @step5 = @step4 * @random
    end

    return @step5.floor
  end

  def random_generator
    random = Random.new
    return random.rand(217..255)
  end

  def winner_checker
    update_all_data_from_db

    if is_defender_hp_zero
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

      if @defender.current_health_point < 0
        @defender.current_health_point = 0
      end

      @defender.save
      
      save_health_point_to_battle_stat
      set_completed_to_battle_status
      # level_up_checker
      
      @battle.save
      @winner.save
      @loser.save
    elsif is_attacker_moves_pp_equal_to_zero
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

      if @defender.current_health_point < 0
        @defender.current_health_point = 0
      end

      @defender.save
      
      save_health_point_to_battle_stat
      set_completed_to_battle_status
      # level_up_checker
      
      @battle.save
      @winner.save
      @loser.save
    end
  end

  def is_defender_hp_zero
    return @defender.current_health_point <= 0
  end

  def is_attacker_moves_pp_equal_to_zero
    # update_all_data_from_db

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
  end

  def save_health_point_to_battle_stat
    # sinkron data antara pokemon1/2 ke defender
    # update_all_data_from_db

    @battle.pokemon_1_health_point = "#{@pokemon1.current_health_point}/#{@pokemon1.max_health_point}"
    @battle.pokemon_2_health_point = "#{@pokemon2.current_health_point}/#{@pokemon2.max_health_point}"

    @battle.save
  end

  def exp_calculation
    return @loser.base_exp * @loser.level / 7
  end
  
  def level_up_checker
    update_all_data_from_db

    @gained_exp = exp_calculation

    @battle.winner_exp_before = "#{@winner.current_exp}/#{@winner.base_exp}"
    
    if @winner.current_exp + @gained_exp == @winner.base_exp
      @winner.current_exp = 0
      
      @level_up_count = 1
    elsif @winner.current_exp + @gained_exp > @winner.base_exp
      @winner.current_exp += @gained_exp

      @level_up_count = @winner.current_exp / @winner.base_exp
      @level_up_count = @level_up_count.floor

      @winner.current_exp %= @winner.base_exp
    elsif @winner.current_exp + @gained_exp < @winner.base_exp
      @winner.current_exp += @gained_exp
    end

    @winner.level += @level_up_count
    # @winner.save

    @battle.winner_gained_exp = @gained_exp
    @battle.winner_level_up_count = @level_up_count

    if @level_up_count > 0
      @winner.attack += random_pokemon_stat_generator
      @winner.defense += random_pokemon_stat_generator
      @winner.special_attack += random_pokemon_stat_generator
      @winner.special_defense += random_pokemon_stat_generator
      @winner.base_exp += random_pokemon_stat_generator
      @winner.max_health_point += random_pokemon_stat_generator
    end

    @battle.save
    @winner.save
    @loser.save
  end

  def random_pokemon_stat_generator
    random = Random.new
    return random.rand(1..5)
  end
  
  def learn_move_quota
    return @level_up_count / 1
  end
  
  def free_move_space
    return 4 - @winner.moves.count
  end
  
  def learn_move_auto_fill
    update_all_data_from_db

    if learn_move_quota <= free_move_space
      index = @winner.moves.count + learn_move_quota - 1

      p "\n==============================="
      p "index: #{index}"
      p "===============================\n"

      if index > 4
        save_health_point_to_battle_stat
        redirect_to pokemon_learn_moves_path(
          @winner, 
          level_up_count: @level_up_count, 
          free_move_space: free_move_space,
          learn_move_quota: learn_move_quota,
        ) and return
      end

      @learnable_move_ids = JSON.parse(@winner.species.learn_move_ids_path)[0..index]

      p "\n==============================="
      p "@learnable_move_ids: #{@learnable_move_ids}"
      p "===============================\n"

      @winner.move_ids = @learnable_move_ids
      @winner.save
      
      @winner.moves_pokemons.each do |moves_pokemon|
        if moves_pokemon.current_power_points.nil?
          move = Move.find(moves_pokemon.move_id)
          moves_pokemon.current_power_points = move.power_points
          moves_pokemon.save
        end
      end
      
      @winner.save
      p "\n==============================="
      p "@winner.moves: #{@winner.moves.pluck(:id, :name)}"
      p "===============================\n"
    # elsif 
    end
  end

  # Only allow a list of trusted parameters through.
  def battle_params
    params.require(:battle).permit(:pokemon_1_id, :pokemon_2_id)
  end
end