module ApplicationHelper

  def current_user_has_provider?(provider, user = current_user)
    user.tokens.by_name(provider).any?
  end

end
