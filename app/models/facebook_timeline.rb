class FacebookTimeline

  attr_reader :authed, :poster_recipient_profile_hash, :commenter_profile_hash

  def initialize(user)
    @user = user
    @authed = true
  end

  def timeline
    token = @user.tokens.find_by(provider: 'facebook')
    facebook_api = FacebookApi.new(token.access_token)
    facebook_api.timeline
    unless facebook_api.success?
      @authed = false
    end
    @poster_recipient_profile_hash = facebook_api.poster_recipient_profile_hash
    @commenter_profile_hash = facebook_api.commenter_profile_hash
    facebook_api.posts
  end

end