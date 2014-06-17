Rails.application.routes.draw do
  root 'welcome#index'
  post '/users', to: 'registrations#create'
  post '/login', to: 'sessions#create'
  get '/destroy', to: 'sessions#destroy'

  get '/feed', to: 'feed#index', as: :feed
  get '/feed_content', to: 'feed#feed', as: :feed_content
  get '/auth/instagram/callback', to: 'instagram_registration#create'
  get '/auth/twitter/callback', to: 'twitter_registration#create'
  get '/auth/facebook/callback', to: 'facebook_registration#create'
  get '/auth/failure', to: 'twitter_registration#failure'
  get '/privacy-policy', to: 'welcome#privacy_policy'
  get '/passwords/reset', to: 'passwords#reset', as: :forgot_password
  post '/passwords', to: 'passwords#send_email'
  put '/passwords', to: 'passwords#update'
  get '/passwords/edit', to: 'passwords#edit', as: :edit_password

  resources :accounts do
    member do
      get 'settings'
    end
  end

  post '/posts', to: 'posts#create', as: :new_post
  post '/twitter/favorite/:tweet_id', to: 'likes#twitter'
  post '/twitter/retweet/:tweet_id', to: 'shares#twitter'
  post '/instagram/like/:media_id', to: 'likes#instagram'
  post '/facebook/like/:post_id', to: 'likes#facebook'
end
