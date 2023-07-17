class BattlesController < ApplicationController
  # GET /battles
  def index
    @battles = Battle.all
  end

  # GET /battles/:battle_id/show
  def show
    @battle = Battle.find(params[:id])
    @pokemon = @battle.pokemon
  end

  # GET /battles/new

  # GET /battles/:battle_id/edit
  
  # POST /battles
end
