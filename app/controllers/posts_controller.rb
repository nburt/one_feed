class PostsController < ApplicationController

  def create
    posts = Posts.new(params, current_user)
    tweet = posts.twitter
    facebook_post = posts.facebook
    unauthed_accounts = posts.unauthed_accounts

    render json: {tweet: tweet, facebook_post: facebook_post, unauthed_accounts: unauthed_accounts}
  end

end