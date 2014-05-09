Rails.application.routes.draw do
  root 'welcome#index'
  get '/register', to: 'registrations#new'
  post '/users', to: 'registrations#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/destroy', to: 'sessions#destroy'
  get '/feed', to: 'feed#index'

  get '/auth/:provider/callback', to: 'twitter_registration#create'
  get '/auth/failure', to: 'twitter_registration#failure'
end
