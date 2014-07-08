describe("FeedIndex", function () {
  var feedIndex;

  it("should have variables set when created", function () {
    var $content = $("<div>");
    feedIndex = new FeedIndex($content);
    feedIndex.providers = {facebook: true, twitter: false, instagram: true};

    expect(feedIndex.el).toEqual($content);
    expect(feedIndex.reloadOk).toEqual(false);
    expect(feedIndex.canCreatePost).toEqual(true);
    expect(feedIndex.providers.instagram).toEqual(true);
    expect(feedIndex.providers.facebook).toEqual(true);
    expect(feedIndex.providers.twitter).toEqual(false);
    $('#jasmine_content').empty();
  });

  describe("getting the initial feed", function () {

    var $content, feedIndex;

    beforeEach(function () {
      jasmine.Ajax.install();
    });

    afterEach(function () {
      jasmine.Ajax.uninstall();
      $('#jasmine_content').empty();
    });

    it("should make a feed request on initialize", function () {
      $content = $('<div class="loading_message"><p class="loading_text">Loading...</p></div>');
      feedIndex = new FeedIndex($content);

      feedIndex.initialize();

      expect(jasmine.Ajax.requests.mostRecent().url).toBe("/feed_content");
    });

    it("should add the initial feed request response to the DOM", function () {
      var fixture = $('<div id="feed_container"> </div> <div class="loading_message"> <p class="loading_text">Loading...</p> </div>');
      $('#jasmine_content').append(fixture);
      var initialFeedResponse = TestResponses.initialFeedResponse.success.responseText;
      feedIndex = new FeedIndex();
      feedIndex.providers = {facebook: true, twitter: true, instagram: true};
      expect(feedIndex.reloadOk).toEqual(false);

      feedIndex.initialFeedSuccess(initialFeedResponse);

      expect(feedIndex.reloadOk).toEqual(true);
      expect($('#feed_container')).toContainText('@TechCrunch');
    });
  });

  describe("getting posts after the initial feed", function () {

    afterEach(function () {
      $('#jasmine_content').empty();
    });

    it("can tell if a reload is available", function () {
      feedIndex = new FeedIndex();
      feedIndex.providers = {facebook: true, twitter: true, instagram: true};
      expect(feedIndex.isReloadAvailable(500, 500)).toEqual(false);
      feedIndex.reloadOk = true;
      expect(feedIndex.isReloadAvailable(500, 500)).toEqual(true);
      expect(feedIndex.isReloadAvailable(8000, 100)).toEqual(false);
      feedIndex.providers.instagram = false;
      feedIndex.providers.twitter = false;
      feedIndex.providers.facebook = false;
      expect(feedIndex.isReloadAvailable(500, 500)).toEqual(false);
      feedIndex.providers.instagram = true;
      expect(feedIndex.isReloadAvailable(500, 500)).toEqual(true);
    });

    it("will add a successful response to the DOM", function () {
      var fixture = $('<div id="feed_container"><div class="load_posts_link"><a href="/feed_content?facebook_pagination_id=738694135382969310_152721" id="load-more">Load more posts</a></div></div>');
      $('#jasmine_content').append(fixture);
      var subsequentFeedRequest = TestResponses.subsequentFeedResponse.success.responseText;
      feedIndex = new FeedIndex();
      feedIndex.providers = {facebook: true, twitter: true, instagram: true};
      feedIndex.nextFeedSuccess(subsequentFeedRequest);

      expect(feedIndex.reloadOk).toEqual(true);
      expect($('#feed_container')).toContainText('hello');
    });
  });

  describe("creating posts", function () {
    beforeEach(function () {
      jasmine.Ajax.install();
    });

    afterEach(function () {
      jasmine.Ajax.uninstall();
      $('#jasmine_content').empty();
    });

    it("can show the create post form", function () {
      var fixture = $('<div class="content_container"><div id="feed_content"><aside><ul id="secondary_nav"><li><a class="create_post_link" href="/posts">Create Post</a></li></ul></aside></div></div>');
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.providers = {facebook: true, twitter: true };
      feedIndex.setupCreatingPost();
      $('.create_post_link').click();
      expect(feedIndex.canCreatePost).toEqual(false);
      expect($('#jasmine_content')).toContainText('Choose which networks to post to:');
      expect($('#jasmine_content')).toContainText('Twitter');
      expect($('#jasmine_content')).toContainText('Facebook');
    });

    it("can show the create post form with only one provider", function () {
      var fixture = $('<div class="content_container"><div id="feed_content"><aside><ul id="secondary_nav"><li><a class="create_post_link" href="/posts">Create Post</a></li></ul></aside></div></div>');
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.providers = {facebook: true, twitter: false, instagram: false};
      feedIndex.setupCreatingPost();
      $('.create_post_link').click();
      expect(feedIndex.canCreatePost).toEqual(false);
      expect($('#jasmine_content')).toContainText('Choose which networks to post to:');
      expect($('#jasmine_content')).toContainText('Facebook');
    });

    it("cannot create posts if canCreatePost is false", function () {
      var fixture = $('<div class="content_container"><div id="feed_content"><aside><ul id="secondary_nav"><li><a class="create_post_link" href="/posts">Create Post</a></li></ul></aside></div></div>');
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.canCreatePost = false;
      feedIndex.setupCreatingPost();
      $('.create_post_link').click();
      expect($('#jasmine_content')).not.toContainText('Choose which networks to post to:');
    });

    it("makes an ajax call on submit of the create post form", function () {
      var fixture = '<form id="create_post_form" action="#" name="create_post_form" data-behavior="/posts"><div id="create_posts_container"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;"/><input name="authenticity_token" type="hidden" value="sx9Uqe9Rt0WYna5MBqHA/bDQmJJfrE8c/sIUjiQJN/w="/></div><div id="post_content_container"><label for="post_content">Post content</label><textarea id="post_content" name="post" placeholder="Share something awesome!"></textarea></div><div id="post_checkbox_container"><label>Choose which networks to post to:</label><label for="provider_twitter">Twitter</label><input id="provider_twitter" name="provider[twitter]" type="checkbox" value="0"/><label for="provider_facebook">Facebook</label><input id="provider_facebook" name="provider[facebook]" type="checkbox" value="0"/></div><div id="create_post_button_container"><button type="submit">Create Post</button><button id="js-cancel-button">Cancel</button></div></div></form>'
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.createPost(feedIndex.createPostSuccess, feedIndex.validatePostTextarea, feedIndex.validatePostCheckboxes);
      document.forms.create_post_form.post.value = "foo";
      $(document.forms.create_post_form).find('input[type=checkbox]')[0].checked = true;
      $('button[type=submit]').click();
      expect(jasmine.Ajax.requests.mostRecent().url).toBe("/posts?post=foo&twitter=true&facebook=false");
    });

    it("adds a post to the DOM when it has been successfully created", function () {
      var fixture = $('<div id="feed_container"></div>');
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.images = {
        facebook: "FB-f-Logo__blue_50.png"
      };
      feedIndex.unauthed_accounts = [];
      feedIndex.tweet = null;
      feedIndex.facebook_post = FacebookCreatePostResponse;
      feedIndex.createPostSuccess(feedIndex);
      expect($('#jasmine_content')).not.toHaveId($("#create_post_form"));
      expect($('#jasmine_content')).toContainText("Hello");
    });

    it("if there are unauthed accounts when creating a post, they are added to the DOM", function () {
      var fixture = $('<div id="feed_container"></div>');
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.createPostSuccess(TestResponses.initialFeedResponse.unauthed.responseText);
      expect($('#jasmine_content')).toContainText("Facebook:");
      expect($('#jasmine_content')).toContainText("Twitter:");
      expect($('#jasmine_content')).toContainText("Authorization for the following accounts has expired");
    });

    it("allows you to click 'Cancel' and it will remove the create post form from the DOM", function () {
      var fixture = '<form id="create_post_form" action="#" name="create_post_form" data-behavior="/posts"><div id="create_posts_container"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;"/><input name="authenticity_token" type="hidden" value="sx9Uqe9Rt0WYna5MBqHA/bDQmJJfrE8c/sIUjiQJN/w="/></div><div id="post_content_container"><label for="post_content">Post content</label><textarea id="post_content" name="post" placeholder="Share something awesome!"></textarea></div><div id="post_checkbox_container"><label>Choose which networks to post to:</label><label for="provider_twitter">Twitter</label><input id="provider_twitter" name="provider[twitter]" type="checkbox" value="0"/><label for="provider_facebook">Facebook</label><input id="provider_facebook" name="provider[facebook]" type="checkbox" value="0"/></div><div id="create_post_button_container"><button type="submit">Create Post</button><button id="js-cancel-button">Cancel</button></div></div></form>'
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.cancelCreatePost();
      $('#js-cancel-button').click();
      expect($('#jasmine_content')).not.toContainText('Choose which networks to post to:');
      expect($('#jasmine_content')).not.toContainText('Facebook');
    });
  });

  describe("validations for creating a post", function () {

    afterEach(function () {
      $('#jasmine_content').empty();
    });

    it("returns false if the text field is empty", function () {
      var fixture = '<form id="create_post_form" action="#" name="create_post_form" data-behavior="/posts"><div id="create_posts_container"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;"/><input name="authenticity_token" type="hidden" value="sx9Uqe9Rt0WYna5MBqHA/bDQmJJfrE8c/sIUjiQJN/w="/></div><div id="post_content_container"><label for="post_content">Post content</label><textarea id="post_content" name="post" placeholder="Share something awesome!"></textarea></div><div id="post_checkbox_container"><label>Choose which networks to post to:</label><label for="provider_twitter">Twitter</label><input id="provider_twitter" name="provider[twitter]" type="checkbox" value="0"/><label for="provider_facebook">Facebook</label><input id="provider_facebook" name="provider[facebook]" type="checkbox" value="0"/></div><div id="create_post_button_container"><button type="submit">Create Post</button><button id="js-cancel-button">Cancel</button></div></div></form>'
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      expect(feedIndex.validatePostTextarea()).toEqual(false);
    });

    it("returns true if the text field is filled", function () {
      var fixture = '<form id="create_post_form" action="#" name="create_post_form" data-behavior="/posts"><div id="create_posts_container"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;"/><input name="authenticity_token" type="hidden" value="sx9Uqe9Rt0WYna5MBqHA/bDQmJJfrE8c/sIUjiQJN/w="/></div><div id="post_content_container"><label for="post_content">Post content</label><textarea id="post_content" name="post" placeholder="Share something awesome!"></textarea></div><div id="post_checkbox_container"><label>Choose which networks to post to:</label><label for="provider_twitter">Twitter</label><input id="provider_twitter" name="provider[twitter]" type="checkbox" value="0"/><label for="provider_facebook">Facebook</label><input id="provider_facebook" name="provider[facebook]" type="checkbox" value="0"/></div><div id="create_post_button_container"><button type="submit">Create Post</button><button id="js-cancel-button">Cancel</button></div></div></form>'
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      document.forms.create_post_form.post.value = "foo";
      expect(feedIndex.validatePostTextarea()).toEqual(true);
    });

    it("returns false if you haven't checked a provider", function () {
      var fixture = '<form id="create_post_form" action="#" name="create_post_form" data-behavior="/posts"><div id="create_posts_container"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;"/><input name="authenticity_token" type="hidden" value="sx9Uqe9Rt0WYna5MBqHA/bDQmJJfrE8c/sIUjiQJN/w="/></div><div id="post_content_container"><label for="post_content">Post content</label><textarea id="post_content" name="post" placeholder="Share something awesome!"></textarea></div><div id="post_checkbox_container"><label>Choose which networks to post to:</label><label for="provider_twitter">Twitter</label><input id="provider_twitter" name="provider[twitter]" type="checkbox" value="0"/><label for="provider_facebook">Facebook</label><input id="provider_facebook" name="provider[facebook]" type="checkbox" value="0"/></div><div id="create_post_button_container"><button type="submit">Create Post</button><button id="js-cancel-button">Cancel</button></div></div></form>'
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      expect(feedIndex.validatePostCheckboxes()).toEqual(false);
    });

    it("returns true if you have checked a provider", function () {
      var fixture = '<form id="create_post_form" action="#" name="create_post_form" data-behavior="/posts"><div id="create_posts_container"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;"/><input name="authenticity_token" type="hidden" value="sx9Uqe9Rt0WYna5MBqHA/bDQmJJfrE8c/sIUjiQJN/w="/></div><div id="post_content_container"><label for="post_content">Post content</label><textarea id="post_content" name="post" placeholder="Share something awesome!"></textarea></div><div id="post_checkbox_container"><label>Choose which networks to post to:</label><label for="provider_twitter">Twitter</label><input id="provider_twitter" name="provider[twitter]" type="checkbox" value="0"/><label for="provider_facebook">Facebook</label><input id="provider_facebook" name="provider[facebook]" type="checkbox" value="0"/></div><div id="create_post_button_container"><button type="submit">Create Post</button><button id="js-cancel-button">Cancel</button></div></div></form>'
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      $(document.forms.create_post_form).find('input[type=checkbox]')[0].checked = true;
      expect(feedIndex.validatePostCheckboxes()).toEqual(true);
      $(document.forms.create_post_form).find('input[type=checkbox]')[0].checked = false;
      expect(feedIndex.validatePostCheckboxes()).toEqual(false);
      $(document.forms.create_post_form).find('input[type=checkbox]')[1].checked = true;
    });
  });

  describe("favoriting/liking posts", function () {
    beforeEach(function () {
      jasmine.Ajax.install();
    });

    afterEach(function () {
      jasmine.Ajax.uninstall();
      $('#jasmine_content').empty();
    });

    it("makes an ajax call to favorite a tweet", function () {
      var fixture = '<div class="individual_post twitter_post" data-id="484045165879758848"><div class="network_logo"><img alt="Twitter logo blue" class="provider_logo" src="/assets/Twitter_logo_blue.png"></div><div class="post_main"><div class="post_header"><ul><li><a href="https://twitter.com/TechCrunch" target="_blank"><img alt="Rkzr1jih normal" class="user_profile_picture" src="https://pbs.twimg.com/profile_images/469171480832380928/rkZR1jIh_normal.png"></a></li><li><a href="https://twitter.com/TechCrunch" target="_blank">TechCrunch</a></li><li>@TechCrunch</li><li><abbr class="timeago" title="2014-07-01 12:45:35 -0600" style="border: none;">8 minutes ago</abbr></li></ul></div><div class="post_content"><ul><li>Kudoso Is A Router That Rewards Your Kids With Facebook Time For Studying, Doing Chores http://t.co/wylBWAoLU1 by @sarahintampa</li></ul><div class="post_stats"><ul><li data-twitter-retweet-count=""><a href="/twitter/retweet/484045165879758848">Retweet:</a> <span class="js-twitter-retweet-count">2</span></li><li data-twitter-favorite-count="484045165879758848"><a href="/twitter/favorite/484045165879758848">Favorite:</a> <span class="js-twitter-favorite-count">3</span></li><li><a href="https://twitter.com/TechCrunch/status/484045165879758848" target="_blank">View on Twitter</a></li></ul></div></div></div></div>'
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.twitterFavorite(feedIndex.twitterFavoriteSuccess);
      $('[data-twitter-favorite-count]').click();
      expect(jasmine.Ajax.requests.mostRecent().url).toBe("/twitter/favorite/484045165879758848");
    });

    it("replaces the twitter favorite count upon a successful response", function () {
      var fixture = '<div class="individual_post twitter_post" data-id="484045165879758848"><div class="network_logo"><img alt="Twitter logo blue" class="provider_logo" src="/assets/Twitter_logo_blue.png"></div><div class="post_main"><div class="post_header"><ul><li><a href="https://twitter.com/TechCrunch" target="_blank"><img alt="Rkzr1jih normal" class="user_profile_picture" src="https://pbs.twimg.com/profile_images/469171480832380928/rkZR1jIh_normal.png"></a></li><li><a href="https://twitter.com/TechCrunch" target="_blank">TechCrunch</a></li><li>@TechCrunch</li><li><abbr class="timeago" title="2014-07-01 12:45:35 -0600" style="border: none;">8 minutes ago</abbr></li></ul></div><div class="post_content"><ul><li>Kudoso Is A Router That Rewards Your Kids With Facebook Time For Studying, Doing Chores http://t.co/wylBWAoLU1 by @sarahintampa</li></ul><div class="post_stats"><ul><li data-twitter-retweet-count=""><a href="/twitter/retweet/484045165879758848">Retweet:</a> <span class="js-twitter-retweet-count">2</span></li><li data-twitter-favorite-count="484045165879758848"><a href="/twitter/favorite/484045165879758848">Favorite:</a> <span class="js-twitter-favorite-count">3</span></li><li><a href="https://twitter.com/TechCrunch/status/484045165879758848" target="_blank">View on Twitter</a></li></ul></div></div></div></div>';
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      var $target = $('[data-twitter-favorite-count]');
      var response = TwitterFavoriteResponse;
      feedIndex.twitterFavoriteSuccess($target, response);
      expect($('#jasmine_content')).toContainText("4");
    });

    it("makes an ajax call to like a facebook post", function () {
      var fixture = TestResponses.facebookPost.success.responseText.fragment;
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.facebookLike(feedIndex.facebookLikeSuccess);
      $('[data-facebook-like-count]').click();
      expect(jasmine.Ajax.requests.mostRecent().url).toBe("/facebook/like/1396087480675877_1435904106694214");
    });

    it("replaces the facebook like count upon a successful response", function () {
      var fixture = '<div class="individual_post facebook_post"><div class="network_logo"><img alt="Fb f logo  blue 50" class="provider_logo" src="/assets/FB-f-Logo__blue_50.png"></div><div class="post_main"><div class="post_header"><ul id="facebook_post_header"><li><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank"><img alt="10298929 1426091331008825 4981210231336248758 n" class="user_profile_picture" src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/c5.0.50.50/p50x50/10298929_1426091331008825_4981210231336248758_n.jpg"></a></li><li><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank">Tom Amhbciaegaeb Lauescu</a></li><li><abbr class="timeago" title="2014-07-01 08:44:00 -0600" style="border: none;">about 8 hours ago</abbr></li></ul><div class="subheader"><ul><li>via OneFeed Staging - local dev</li></ul></div></div><div class="post_content"><ul><li>Hello</li></ul><div class="post_stats"><ul><li>Comment</li><li data-facebook-comments="1396087480675877_1436442189973739">View Comments: 0</li><li class="facebook_hide_comments"><a class="facebook_hide_comments_link" href="/facebook/comment/1396087480675877_1436442189973739">Hide Comments:</a> 0</li><li data-facebook-like-count="1396087480675877_1436442189973739"><a href="/facebook/like/1396087480675877_1436442189973739">Like:</a> <span class="js-facebook-like-count">0</span></li><li><a href="https://www.facebook.com/1396087480675877/posts/1436442189973739" target="_blank">View on Facebook</a></li></ul></div></div></div></div>';
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      var $target = $('[data-facebook-like-count]');
      var response = FacebookLikeResponse;
      feedIndex.facebookLikeSuccess($target, response);
      expect($('#jasmine_content')).toContainText("1")
    });

    it("makes an ajax call to like an instagram post", function () {
      var fixture = TestResponses.instagramPost.success.responseText.fragment;
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.instagramLike(feedIndex.instagramLikeSuccess);
      $('[data-instagram-like-count]').click();
      expect(jasmine.Ajax.requests.mostRecent().url).toBe("/instagram/like/752826932611680976_152721")
    });

    it("replaces the instagram like count upon a successful response", function () {
      var fixture = '<div class="individual_post instagram_post"><div class="network_logo"><img alt="Instagram icon large" class="provider_logo" src="/assets/Instagram_Icon_Large.png"></div><div class="post_main"><div class="post_header"><ul><li><a href="http://www.instagram.com/adamsenatori" target="_blank"><img alt="Profile 152721 75sq 1392851165" class="user_profile_picture" src="http://images.ak.instagram.com/profiles/profile_152721_75sq_1392851165.jpg"></a></li><li><a href="http://www.instagram.com/adamsenatori" target="_blank">@adamsenatori</a></li><li><abbr class="timeago" title="2014-06-30 20:00:02 -0600" style="border: none;">a day ago</abbr></li></ul></div><div class="post_content"><ul><li><img alt="10488786 1507205686159375 2107952782 a" src="http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/10488786_1507205686159375_2107952782_a.jpg"></li><li>Fly helicopters not drones / Montana USA</li></ul><div class="post_stats"><ul><li>Comment</li><li data-instagram-comments="754639014445353936_152721"><a class="instagram_show_comments_link" href="/instagram/comment/754639014445353936_152721">View Comments:</a> 64</li><li class="instagram_hide_comments"><a class="instagram_hide_comments_link" href="/instagram/comment/754639014445353936_152721">Hide Comments:</a> 64</li><li data-instagram-like-count="754639014445353936_152721"><a href="/instagram/like/754639014445353936_152721">Like:</a><span class="js-instagram-like-count">7976</span></li><li><a href="http://instagram.com/p/p5BC91qovQ/" target="_blank">View on Instagram</a></li></ul></div></div></div></div>';
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      var $target = $('[data-instagram-like-count]');
      var response = InstagramLikeResponse;
      feedIndex.instagramLikeSuccess($target, response);
      expect($('#jasmine_content')).toContainText("7977");
    });
  });

  describe("sharing posts", function () {
    beforeEach(function () {
      jasmine.Ajax.install();
    });

    afterEach(function () {
      jasmine.Ajax.uninstall();
      $('#jasmine_content').empty();
    });

    it("makes an ajax call to retweet a tweet", function () {
      var fixture = TestResponses.twitterPost.success.responseText.fragment;
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.twitterRetweet(feedIndex.twitterFavoriteSuccess);
      $('[data-twitter-retweet-count]').click();
      expect(jasmine.Ajax.requests.mostRecent().url).toBe("/twitter/retweet/481919606580207616");
    });

    it("replaces the twitter retweet count upon a successful response", function () {
      var fixture = '<div class="individual_post twitter_post" data-id="484163625137889280"><div class="network_logo"><img alt="Twitter logo blue" class="provider_logo" src="/assets/Twitter_logo_blue.png"></div><div class="post_main"><div class="post_header"><ul><li><a href="https://twitter.com/TechCrunch" target="_blank"><img alt="Rkzr1jih normal" class="user_profile_picture" src="https://pbs.twimg.com/profile_images/469171480832380928/rkZR1jIh_normal.png"></a></li><li><a href="https://twitter.com/TechCrunch" target="_blank">TechCrunch</a></li><li>@TechCrunch</li><li><abbr class="timeago" title="2014-07-01 20:36:18 -0600" style="border: none;">31 minutes ago</abbr></li></ul></div><div class="post_content"><ul><li>Play With Googles Psychedelic New Interactive Music Video Cube http://t.co/QKo7FaOL9S by @joshconstine</li></ul><div class="post_stats"><ul><li data-twitter-retweet-count=""><a href="/twitter/retweet/484163625137889280">Retweet:</a> <span class="js-twitter-retweet-count">22</span></li><li data-twitter-favorite-count="484163625137889280"><a href="/twitter/favorite/484163625137889280">Favorite:</a> <span class="js-twitter-favorite-count">13</span></li><li><a href="https://twitter.com/TechCrunch/status/484163625137889280" target="_blank">View on Twitter</a></li></ul></div></div></div></div>'
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      var $target = $('[data-twitter-retweet-count]');
      var response = TwitterRetweetResponse
      feedIndex.twitterRetweetSuccess($target, response);
      expect($('#jasmine_content')).toContainText("23");
    });

  });

  describe("viewing and hiding comments", function () {
    beforeEach(function () {
      jasmine.Ajax.install();
    });

    afterEach(function () {
      jasmine.Ajax.uninstall();
      $('#jasmine_content').empty();
    });

    it("makes an ajax request when you click view comments for an instagram post", function () {
      var fixture = '<div class="individual_post instagram_post"><div class="network_logo"><img alt="Instagram icon large" class="provider_logo" src="/assets/Instagram_Icon_Large.png"></div><div class="post_main"><div class="post_header"><ul><li><a href="http://www.instagram.com/adamsenatori" target="_blank"><img alt="Profile 152721 75sq 1392851165" class="user_profile_picture" src="http://images.ak.instagram.com/profiles/profile_152721_75sq_1392851165.jpg"></a></li><li><a href="http://www.instagram.com/adamsenatori" target="_blank">@adamsenatori</a></li><li><abbr class="timeago" title="2014-06-30 20:00:02 -0600" style="border: none;">a day ago</abbr></li></ul></div><div class="post_content"><ul><li><img alt="10488786 1507205686159375 2107952782 a" src="http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/10488786_1507205686159375_2107952782_a.jpg"></li><li>Fly helicopters not drones / Montana USA</li></ul><div class="post_stats"><ul><li>Comment</li><li data-instagram-comments="754639014445353936_152721"><a class="instagram_show_comments_link" href="/instagram/comment/754639014445353936_152721">View Comments:</a> 64</li><li class="instagram_hide_comments"><a class="instagram_hide_comments_link" href="/instagram/comment/754639014445353936_152721">Hide Comments:</a> 64</li><li data-instagram-like-count="754639014445353936_152721"><a href="/instagram/like/754639014445353936_152721">Like:</a><span class="js-instagram-like-count">7976</span></li><li><a href="http://instagram.com/p/p5BC91qovQ/" target="_blank">View on Instagram</a></li></ul></div></div></div></div>'
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.showInstagramComments(feedIndex.showInstagramCommentsSuccess);
      $('.instagram_show_comments_link').click();
      expect(jasmine.Ajax.requests.mostRecent().url).toBe("/instagram/comment/754639014445353936_152721");
    });

    it("adds instagram comments to the dom upon a successful ajax request", function () {
      var fixture = '<div class="individual_post instagram_post"><div class="network_logo"><img alt="Instagram icon large" class="provider_logo" src="/assets/Instagram_Icon_Large.png"></div><div class="post_main"><div class="post_header"><ul><li><a href="http://www.instagram.com/adamsenatori" target="_blank"><img alt="Profile 152721 75sq 1392851165" class="user_profile_picture" src="http://images.ak.instagram.com/profiles/profile_152721_75sq_1392851165.jpg"></a></li><li><a href="http://www.instagram.com/adamsenatori" target="_blank">@adamsenatori</a></li><li><abbr class="timeago" title="2014-06-30 20:00:02 -0600" style="border: none;">a day ago</abbr></li></ul></div><div class="post_content"><ul><li><img alt="10488786 1507205686159375 2107952782 a" src="http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/10488786_1507205686159375_2107952782_a.jpg"></li><li>Fly helicopters not drones / Montana USA</li></ul><div class="post_stats"><ul><li>Comment</li><li data-instagram-comments="754639014445353936_152721" style="display: inline;"><a href="/instagram/comment/754639014445353936_152721" class="instagram_show_comments_link">View Comments: </a>1</li><li class="instagram_hide_comments" style="display: none;"><a href="/instagram/comment/754639014445353936_152721" class="instagram_hide_comments_link">Hide Comments: </a>1</li><li data-instagram-like-count="754639014445353936_152721"><a href="/instagram/like/754639014445353936_152721">Like:</a><span class="js-instagram-like-count">8182</span></li><li><a href="http://instagram.com/p/p5BC91qovQ/" target="_blank">View on Instagram</a></li></ul></div></div></div></div>';
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      var $target = $('[data-instagram-comments]');
      var response = InstagramShowCommentsResponse;
      feedIndex.showInstagramCommentsSuccess($target, response);
      expect($('#jasmine_content')).toContainText("Awesome pic");
      expect($('#jasmine_content')).toContainText("2");
      expect($('[data-instagram-comments]')).toBeHidden();
    });

    it("removes instagram comments from the dom when you click on hide comments", function () {
      var fixture = '<div class="individual_post instagram_post"><div class="network_logo"><img alt="Instagram icon large" class="provider_logo" src="/assets/Instagram_Icon_Large.png"></div><div class="post_main"><div class="post_header"><ul><li><a href="http://www.instagram.com/adamsenatori" target="_blank"><img alt="Profile 152721 75sq 1392851165" class="user_profile_picture" src="http://images.ak.instagram.com/profiles/profile_152721_75sq_1392851165.jpg"></a></li><li><a href="http://www.instagram.com/adamsenatori" target="_blank">@adamsenatori</a></li><li><abbr class="timeago" title="2014-06-30 20:00:02 -0600" style="border: none;">a day ago</abbr></li></ul></div><div class="post_content"><ul><li><img alt="10488786 1507205686159375 2107952782 a" src="http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/10488786_1507205686159375_2107952782_a.jpg"></li><li>Fly helicopters not drones / Montana USA</li></ul><div class="post_stats"><ul><li>Comment</li><li data-instagram-comments="754639014445353936_152721" style="display: inline;"><a href="/instagram/comment/754639014445353936_152721" class="instagram_show_comments_link">View Comments: </a>1</li><li class="instagram_hide_comments" style="display: none;"><a href="/instagram/comment/754639014445353936_152721" class="instagram_hide_comments_link">Hide Comments: </a>1</li><li data-instagram-like-count="754639014445353936_152721"><a href="/instagram/like/754639014445353936_152721">Like:</a><span class="js-instagram-like-count">8182</span></li><li><a href="http://instagram.com/p/p5BC91qovQ/" target="_blank">View on Instagram</a></li></ul></div><div class="post_comments"><ul><li class="commenter_profile_picture"><a href="http://www.instagram.com/kikoluzz" target="_blank"><img src="http://photos-a.ak.instagram.com/hphotos-ak-xpf1/10424543_463736443729416_754644228_a.jpg"></a></li><li>Awesome pic</li></ul></div></div></div></div>';
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.hideInstagramComments(feedIndex.hideProviderComments);
      expect($('#jasmine_content')).toContainText("Awesome pic");
      $('.instagram_hide_comments_link').click();
      expect($('.post_comments')).not.toBeInDOM();
      expect($('[data-instagram-comments]')).not.toBeHidden();
      expect($('.instagram_hide_comments')).toBeHidden();
    });

    it("makes an ajax request when you click view comments for a facebook post", function () {
      var fixture = '<div class="individual_post facebook_post"><div class="network_logo"><img alt="Fb f logo  blue 50" class="provider_logo" src="/assets/FB-f-Logo__blue_50.png"></div><div class="post_main"><div class="post_header"><ul id="facebook_post_header"><li><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank"><img alt="10298929 1426091331008825 4981210231336248758 n" class="user_profile_picture" src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/c5.0.50.50/p50x50/10298929_1426091331008825_4981210231336248758_n.jpg"></a></li><li><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank">Tom Amhbciaegaeb Lauescu</a></li><li><abbr class="timeago" title="2014-07-02 12:28:33 -0600" style="border: none;">4 minutes ago</abbr></li></ul><div class="subheader"><ul><li>via OneFeed Staging - local dev</li></ul></div></div><div class="post_content"><ul><li>hello</li></ul><div class="post_stats"><ul><li>Comment</li><li data-facebook-comments="1396087480675877_1437097303241561" style="display: inline;"><a href="/facebook/comment/1396087480675877_1437097303241561" class="facebook_show_comments_link">View Comments: </a>1</li><li class="facebook_hide_comments" style="display: none;"><a href="/facebook/comment/1396087480675877_1437097303241561" class="facebook_hide_comments_link">Hide Comments: </a>1</li><li data-facebook-like-count="1396087480675877_1437097303241561"><a href="/facebook/like/1396087480675877_1437097303241561">Like:</a> <span class="js-facebook-like-count">0</span></li><li><a href="https://www.facebook.com/1396087480675877/posts/1437097303241561" target="_blank">View on Facebook</a></li></ul></div></div></div></div>';
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.showFacebookComments(feedIndex.showFacebookCommentsSuccess);
      $('.facebook_show_comments_link').click();
      expect(jasmine.Ajax.requests.mostRecent().url).toBe("/facebook/comment/1396087480675877_1437097303241561");
    });

    it("adds facebook comments to the dom upon a successful ajax request", function () {
      var fixture = '<div class="individual_post facebook_post"><div class="network_logo"><img alt="Fb f logo  blue 50" class="provider_logo" src="/assets/FB-f-Logo__blue_50.png"></div><div class="post_main"><div class="post_header"><ul id="facebook_post_header"><li><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank"><img alt="10298929 1426091331008825 4981210231336248758 n" class="user_profile_picture" src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/c5.0.50.50/p50x50/10298929_1426091331008825_4981210231336248758_n.jpg"></a></li><li><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank">Tom Amhbciaegaeb Lauescu</a></li><li><abbr class="timeago" title="2014-07-02 12:28:33 -0600" style="border: none;">4 minutes ago</abbr></li></ul><div class="subheader"><ul><li>via OneFeed Staging - local dev</li></ul></div></div><div class="post_content"><ul><li>hello</li></ul><div class="post_stats"><ul><li>Comment</li><li data-facebook-comments="1396087480675877_1437097303241561" style="display: inline;"><a href="/facebook/comment/1396087480675877_1437097303241561" class="facebook_show_comments_link">View Comments: </a>1</li><li class="facebook_hide_comments" style="display: none;"><a href="/facebook/comment/1396087480675877_1437097303241561" class="facebook_hide_comments_link">Hide Comments: </a>1</li><li data-facebook-like-count="1396087480675877_1437097303241561"><a href="/facebook/like/1396087480675877_1437097303241561">Like:</a> <span class="js-facebook-like-count">0</span></li><li><a href="https://www.facebook.com/1396087480675877/posts/1437097303241561" target="_blank">View on Facebook</a></li></ul></div></div></div></div>';
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      var $target = $('[data-facebook-comments]');
      var response = FacebookShowCommentsResponse;
      feedIndex.showFacebookCommentsSuccess($target, response);
      expect($('#jasmine_content')).toContainText("yooo");
      expect($('#jasmine_content')).toContainText("2");
      expect($('[data-facebook-comments]')).toBeHidden();
    });

    it("removes facebook comments from the dom when you click on hide comments", function () {
      var fixture = '<div class="individual_post facebook_post"><div class="network_logo"><img alt="Fb f logo  blue 50" class="provider_logo" src="/assets/FB-f-Logo__blue_50.png"></div><div class="post_main"><div class="post_header"><ul id="facebook_post_header"><li><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank"><img alt="10298929 1426091331008825 4981210231336248758 n" class="user_profile_picture" src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/c5.0.50.50/p50x50/10298929_1426091331008825_4981210231336248758_n.jpg"></a></li><li><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank">Tom Amhbciaegaeb Lauescu</a></li><li><abbr class="timeago" title="2014-07-02 12:28:33 -0600" style="border: none;">16 minutes ago</abbr></li></ul><div class="subheader"><ul><li>via OneFeed Staging - local dev</li></ul></div></div><div class="post_content"><ul><li>hello</li></ul><div class="post_stats"><ul><li>Comment</li><li data-facebook-comments="1396087480675877_1437097303241561" style="display: none;"><a href="/facebook/comment/1396087480675877_1437097303241561" class="facebook_show_comments_link">View Comments: </a>3</li><li class="facebook_hide_comments" style="display: inline-block;"><a href="/facebook/comment/1396087480675877_1437097303241561" class="facebook_hide_comments_link">Hide Comments: </a>3</li><li data-facebook-like-count="1396087480675877_1437097303241561"><a href="/facebook/like/1396087480675877_1437097303241561">Like:</a> <span class="js-facebook-like-count">0</span></li><li><a href="https://www.facebook.com/1396087480675877/posts/1437097303241561" target="_blank">View on Facebook</a></li></ul></div><div class="post_comments"><ul><li class="commenter_profile_picture"><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank"><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/c5.0.50.50/p50x50/10298929_1426091331008825_4981210231336248758_n.jpg"></a></li><li class="commenter_username"><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank">Tom Amhbciaegaeb Lauescu</a></li><li>hey!</li><li class="commenter_profile_picture"><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank"><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/c5.0.50.50/p50x50/10298929_1426091331008825_4981210231336248758_n.jpg"></a></li><li class="commenter_username"><a href="https://www.facebook.com/app_scoped_user_id/1396087480675877" target="_blank">Tom Amhbciaegaeb Lauescu</a></li><li>hi!</li><li class="commenter_profile_picture"><a href="https://www.facebook.com/app_scoped_user_id/1385629225056642" target="_blank"><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/t1.0-1/c10.0.50.50/p50x50/10339716_1385777661708465_5955368705953093888_n.jpg"></a></li><li class="commenter_username"><a href="https://www.facebook.com/app_scoped_user_id/1385629225056642" target="_blank">Barbara Amhbhgccaaae Sadansen</a></li><li>yooo</li></ul></div></div></div></div>';
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.hideFacebookComments(feedIndex.hideProviderComments);
      expect($('#jasmine_content')).toContainText("yooo");
      $('.facebook_hide_comments_link').click();
      expect($('.post_comments')).not.toBeInDOM();
      expect($('[data-facebook-comments]')).not.toBeHidden();
      expect($('.facebook_hide_comments')).toBeHidden();
    });
  });

  describe("toggling posts", function () {
    afterEach(function () {
      $('#jasmine_content').empty();
    });

    it("can toggle twitter posts", function () {
      var fixture1 = $('<aside><ul id="secondary_nav"><li><a href="#" id="twitter_toggle">Toggle Twitter</a></li></ul></aside>');
      var fixture2 = $(TestResponses.initialFeedResponse.success.responseText.fragment);
      $('#jasmine_content').append(fixture1);
      $('#jasmine_content').append(fixture2);

      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.providers = {facebook: true, twitter: true, instagram: true};
      expect(feedIndex.providers.twitter).toEqual(true);
      feedIndex.toggleTwitterPosts(feedIndex.toggleProvider);

      $('#twitter_toggle').click();
      expect(feedIndex.providers.twitter).toEqual(false);
      expect($('.twitter_post')[0]).toBeHidden();
    });

    it("can toggle facebook posts", function () {
      var fixture1 = $('<aside><ul id="secondary_nav"><li><a href="#" id="facebook_toggle">Toggle Facebook</a></li></ul></aside>');
      var fixture2 = $(TestResponses.facebookPost.success.responseText.fragment);
      $('#jasmine_content').append(fixture1);
      $('#jasmine_content').append(fixture2);

      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.providers = {facebook: true, twitter: true, instagram: true};
      expect(feedIndex.providers.facebook).toEqual(true);
      feedIndex.toggleFacebookPosts(feedIndex.toggleProvider);

      $('#facebook_toggle').click();
      expect(feedIndex.providers.facebook).toEqual(false);
      expect($('.facebook_post')[0]).toBeHidden();
    });

    it("can toggle instagram posts", function () {
      var fixture1 = $('<aside><ul id="secondary_nav"><li><a href="#" id="instagram_toggle">Toggle Instagram</a></li></ul></aside>');
      var fixture2 = $(TestResponses.instagramPost.success.responseText.fragment);
      $('#jasmine_content').append(fixture1);
      $('#jasmine_content').append(fixture2);

      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.providers = {facebook: true, twitter: true, instagram: true};
      expect(feedIndex.providers.instagram).toEqual(true);
      feedIndex.toggleInstagramPosts(feedIndex.toggleProvider);

      $('#instagram_toggle').click();
      expect(feedIndex.providers.instagram).toEqual(false);
      expect($('.instagram_post')[0]).toBeHidden();
    });

    it("can hide posts", function () {
      var fixture1 = $(TestResponses.facebookPost.success.responseText.fragment);
      var fixture2 = $(TestResponses.instagramPost.success.responseText.fragment);
      var fixture3 = $(TestResponses.twitterPost.success.responseText.fragment);
      $('#jasmine_content').append(fixture1);
      $('#jasmine_content').append(fixture2);
      $('#jasmine_content').append(fixture3);

      feedIndex = new FeedIndex($('#jasmine_content'));
      feedIndex.providers = {facebook: false, twitter: false, instagram: false};
      feedIndex.hidePosts();
      expect($('.instagram_post')[0]).toBeHidden();
      expect($('.facebook_post')[0]).toBeHidden();
      expect($('.twitter_post')[0]).toBeHidden();
    });

    it("can hide the toggle buttons", function () {
      var fixture = '<ul id="secondary_nav"><li><a href="#" id="facebook_toggle">Toggle Facebook</a></li><li><a href="#" id="twitter_toggle">Toggle Twitter</a></li><li><a href="#" id="instagram_toggle">Toggle Instagram</a></li></ul>'
      $('#jasmine_content').append(fixture);
      feedIndex = new FeedIndex();
      feedIndex.providers = {facebook: false, twitter: false, instagram: false};
      feedIndex.toggleProviderButtons();
      expect($('#facebook_toggle')).toBeHidden();
      expect($('#twitter_toggle')).toBeHidden();
      expect($('#instagram_toggle')).toBeHidden();
    });

    it("will hide the toggle buttons if a user's account is unauthed", function () {
      var fixture = $('<div id="feed_container"> </div> <div class="loading_message"> <p class="loading_text">Loading...</p> </div>');
      $('#jasmine_content').append(fixture);
      var initialFeedResponse = TestResponses.initialFeedResponse.unauthed.responseText;
      feedIndex = new FeedIndex();
      feedIndex.providers = {facebook: true, twitter: true, instagram: true};
      feedIndex.render(initialFeedResponse);
      expect(feedIndex.providers.facebook).toEqual(false);
      expect(feedIndex.providers.twitter).toEqual(false);
      expect(feedIndex.providers.instagram).toEqual(false);
    });
  });

  describe("setting providers", function () {
    it("sets instagramShow, facebookShow, and twitterShow", function () {
      feedIndex = new FeedIndex();
      feedIndex.providers = {facebook: true, instagram: true, twitter: true};
      feedIndex.setProviders({facebook: false, instagram: false, twitter: false});
      expect(feedIndex.providers.facebook).toEqual(false);
      expect(feedIndex.providers.instagram).toEqual(false);
      expect(feedIndex.providers.twitter).toEqual(false);
    });
  });
});