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
  get '/privacy-policy', to: 'welcome#privacy_policy'

  resources :accounts do
    member do
      get 'settings'
    end
  end

  resources :posts

  get '/twitter/favorite/:tweet_id', to: 'likes#twitter'
  get '/twitter/retweet/:tweet_id', to: 'shares#twitter'
  get '/instagram/like/:media_id', to: 'likes#instagram'
  get '/facebook/like/:post_id', to: 'likes#facebook'
end
