module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:twitter] = {
      'provider' => 'twitter',
      'uid' => '123545',
      'info' => {
        'name' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      },
      'extra' => {
        'access_token' => access_token_struct.new(1, 2)
      }
    }
    OmniAuth.config.mock_auth[:instagram] = {
      'provider' => 'instagram',
      'uid' => '123546',
      'info' => {
        'name' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token'
      },
      'extra' => {
        'access_token' => access_token_struct.new(1, 2)
      }
    }
  end

  def access_token_struct
    Struct.new(:secret, :token)
  end
end