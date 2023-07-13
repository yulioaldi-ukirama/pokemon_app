Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # Root page
  root 'pokemons#index'
  
  # Pokemons
  get '/pokemons', to: 'pokemons#index', as: 'pokemons_index'
  get '/pokemons/:pokemon_id/show', to:'pokemons#show', as: 'pokemon_show'
  get '/pokemons/new', to: 'pokemons#new', as: 'pokemon_new'

  post '/pokemons', to: 'pokemons#create', as: 'pokemon_create'
end
