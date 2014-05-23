Rails.application.routes.draw do
  root 'welcome#index'
  post '/users', to: 'registrations#create'
  post '/login', to: 'sessions#create'
  get '/destroy', to: 'sessions#destroy'

  get '/feed', to: 'feed#index', as: :feed
  get '/feed_content', to: 'feed#feed'
  get '/auth/instagram/callback', to: 'instagram_registration#create'
  get '/auth/twitter/callback', to: 'twitter_registration#create'
  get '/auth/facebook/callback', to: 'facebook_registration#create'
  get '/auth/failure', to: 'twitter_registration#failure'

  resources :accounts do
    member do
      get 'settings'
    end
  end
end
