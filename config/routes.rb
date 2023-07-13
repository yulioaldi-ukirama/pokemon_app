Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root 'pokemons#index'
  
  # Pokemons
  # get 'pokemons/index'
  get 'pokemons/:pokemon_id/show', to:'pokemons#show', as: 'pokemon_show'
  get 'pokemons/new'
end
