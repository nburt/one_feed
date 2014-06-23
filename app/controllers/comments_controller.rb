class CommentsController < ApplicationController

  def instagram_display
    media_id = params[:media_id]
    tokens = current_user.tokens.find_by(provider: 'instagram')
    instagram_api = Instagram::Api.new(tokens.access_token)
    comments_response = instagram_api.get_comments(media_id)
    comments = comments_response.parse
    render json: {comments: comments}
  end

  def facebook_display
    post_id = params[:post_id]
    tokens = current_user.tokens.find_by(provider: 'facebook')
    facebook_api = Facebook::Api.new(tokens.access_token)
    facebook_api.get_comments(post_id)
    comments =  facebook_api.facebook_post_response.post
    commenter_profile_pictures =  facebook_api.facebook_post_response.commenter_profile_hash
    render json: {comments: comments, commenter_profile_pictures: commenter_profile_pictures}
  end

end