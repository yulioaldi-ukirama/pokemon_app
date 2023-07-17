Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # Root page
  root 'pokemons#index'
  
  # Pokemons
  resources :pokemons

  # get '/pokemons', to: 'pokemons#index', as: 'pokemons_index'
  # get '/pokemons/new', to: 'pokemons#new', as: 'pokemon_new'
  # get '/pokemons/:id/show', to:'pokemons#show', as: 'pokemon_show'
  # get '/pokemons/:id/edit', to: 'pokemons#edit', as: 'pokemon_edit'
  # post '/pokemons', to: 'pokemons#create', as: 'pokemon_create'
  # patch '/pokemons/:id', to: 'pokemons#update', as: 'pokemon_update'
  # delete '/pokemons/:id', to: 'pokemons#destroy', as: 'pokemon_delete'
  
  get '/pokemons/:id/edit_moves', to: 'pokemons#edit_moves', as: 'pokemon_edit_moves'

  post '/pokemons/:id/update_moves', to: 'pokemons#update_moves', as: 'pokemon_update_moves'

  # Battles
end