module FeedFeatureStubs

  def insert_feed_feature_stubs
    stub_request(:post, 'https://api.twitter.com/oauth2/token')

    stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json').
      to_return(body: File.read(File.expand_path('./spec/support/twitter_timeline.json')))

    stub_request(:post, 'https://api.instagram.com/oauth2/token')

    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token').
      to_return(body: File.read(File.expand_path('./spec/support/instagram_timeline.json')))

    stub_request(:get, 'https://graph.facebook.com/me/home?access_token=mock_token').
      to_return(body: File.read(File.expand_path('./spec/support/facebook_timeline.json')))

    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_8.json'))

    stub_request(:get, 'https://graph.facebook.com/2497151503215/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_9.json'))

    stub_request(:get, 'https://graph.facebook.com/2667146361270/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_10.json'))

    stub_request(:get, 'https://graph.facebook.com/10204036212008354/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_11.json'))

    stub_request(:get, 'https://graph.facebook.com/10202029985566360/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_12.json'))

    stub_request(:get, 'https://graph.facebook.com/10152831000093574/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_13.json'))

    stub_request(:get, 'https://graph.facebook.com/667644649949344/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_14.json'))

    stub_request(:get, 'https://graph.facebook.com/10203759523938333/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_15.json'))

    stub_request(:get, 'https://graph.facebook.com/10203663789455592/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_16.json'))

    stub_request(:get, 'https://graph.facebook.com/10202029985486358/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_17.json'))

    stub_request(:get, 'https://graph.facebook.com/767589619947371/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_18.json'))

    stub_request(:get, 'https://graph.facebook.com/10202029985606361/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_19.json'))

    stub_request(:get, 'https://graph.facebook.com/10152398786391740/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_20.json'))

    stub_request(:get, 'https://graph.facebook.com/10202730361274347/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_21.json'))

    stub_request(:get, 'https://graph.facebook.com/662217533851652/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_22.json'))

    stub_request(:get, 'https://graph.facebook.com/411303302345868/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_23.json'))

    stub_request(:get, 'https://graph.facebook.com/101533286554070/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_24.json'))

    stub_request(:get, 'https://graph.facebook.com/2099182036593/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_25.json'))

    stub_request(:get, 'https://graph.facebook.com/10152150512622081/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_26.json'))

    stub_request(:get, 'https://graph.facebook.com/10152103469946088/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_27.json'))

    stub_request(:get, 'https://graph.facebook.com/10154117470710188/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_28.json'))

    stub_request(:get, 'https://graph.facebook.com/10201997202639015/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_29.json'))

    stub_request(:get, 'https://graph.facebook.com/10202056569877879/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_30.json'))

    stub_request(:get, 'https://graph.facebook.com/10201922021604187/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_31.json'))

    stub_request(:get, 'https://graph.facebook.com/10153074975361029/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_32.json'))

    stub_request(:get, 'https://graph.facebook.com/10202029985526359/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_33.json'))

    stub_request(:get, 'https://graph.facebook.com/10152184707078227/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_34.json'))

    stub_request(:get, 'https://graph.facebook.com/2408119482669/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_35.json'))

    stub_request(:get, 'https://graph.facebook.com/2935811685500/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_36.json'))

    stub_request(:get, 'https://graph.facebook.com/10201463369980737/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_37.json'))

    stub_request(:get, 'https://graph.facebook.com/10152375218710700/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_38.json'))

    stub_request(:get, 'https://graph.facebook.com/10202055803224824/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_39.json'))

    stub_request(:get, 'https://graph.facebook.com/10202055803224824/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_40.json'))

    stub_request(:get, 'https://graph.facebook.com/10201747824447839/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_41.json'))
  end

end