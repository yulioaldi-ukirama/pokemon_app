Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # Root page
  root 'pages#home'
  
  # Pokemons
  resources :pokemons

  # get '/pokemons', to: 'pokemons#index', as: 'pokemons_index'
  # get '/pokemons/new', to: 'pokemons#new', as: 'pokemon_new'
  # get '/pokemons/:id/show', to:'pokemons#show', as: 'pokemon_show'
  # get '/pokemons/:id/edit', to: 'pokemons#edit', as: 'pokemon_edit'
  # post '/pokemons', to: 'pokemons#create', as: 'pokemon_create'
  # patch '/pokemons/:id', to: 'pokemons#update', as: 'pokemon_update'
  # delete '/pokemons/:id', to: 'pokemons#destroy', as: 'pokemon_delete'
  
  get '/pokemons/:id/edit_types', to: 'pokemons#edit_types', as: 'pokemon_edit_types'
  get '/pokemons/:id/learn_moves', to: 'pokemons#learn_moves', as: 'pokemon_learn_moves'

  post '/pokemons/:id/update_types', to: 'pokemons#update_types', as: 'pokemon_update_types'
  post '/pokemons/:id/save_learn_moves', to: 'pokemons#save_learn_moves', as: 'pokemon_save_learn_moves'
  post '/pokemons/heals', to: 'pokemons#heals', as: 'pokemon_heals'
  
  # Battles
  resources :battles do
    member do
      post :move
    end
  end
end