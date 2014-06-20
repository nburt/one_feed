class CommentsController < ApplicationController

  def instagram_display
    media_id = params[:media_id]
    tokens = current_user.tokens.find_by(provider: 'instagram')
    instagram_api = Instagram::Api.new(tokens.access_token)
    comments_response = instagram_api.get_comments(media_id)
    comments = comments_response.parse
    render json: {comments: comments}
  end

end