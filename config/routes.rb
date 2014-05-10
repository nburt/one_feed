Rails.application.routes.draw do
  root 'welcome#index'
  post '/users', to: 'registrations#create'
  post '/login', to: 'sessions#create'
  get '/destroy', to: 'sessions#destroy'
  get '/feed', to: 'feed#index'

  get '/auth/:provider/callback', to: 'twitter_registration#create'
  get '/auth/failure', to: 'twitter_registration#failure'
end
