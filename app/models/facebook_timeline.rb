class FacebookTimeline

  attr_reader :authed, :poster_recipient_profile_hash, :commenter_profile_hash, :pagination_id

  def initialize(user)
    @user = user
    @authed = true
  end

  def posts(pagination_id)
    token = user_tokens
    facebook_api = FacebookApi.new(token.access_token, pagination_id)
    begin
      facebook_api.timeline
    rescue FacebookUnauthorized
      @authed = false
    end
    @poster_recipient_profile_hash = facebook_api.poster_recipient_profile_hash
    @commenter_profile_hash = facebook_api.commenter_profile_hash
    @pagination_id = facebook_api.pagination_id
    facebook_api.posts
  end

  private

  def user_tokens
    @user.tokens.find_by(provider: 'facebook')
  end

end