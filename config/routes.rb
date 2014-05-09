Rails.application.routes.draw do
  root 'welcome#index'
  get '/register', to: 'registrations#new'
  post '/users', to: 'registrations#create'
  get '/login', to: 'registrations#login'
  post '/login', to: 'registrations#logged_in'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/destroy', to: 'sessions#destroy'
  get '/auth/failure', to: 'sessions#failure'
end
