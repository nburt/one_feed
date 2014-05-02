Rails.application.routes.draw do
  root 'welcome#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/destroy', to: 'sessions#destroy'
  get '/auth/failure', to: 'sessions#failure'
end
