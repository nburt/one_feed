describe("FeedIndex", function () {
  var feedIndex;

  it("should have variables set when created", function () {
    var $content = $("<div>");
    feedIndex = new FeedIndex($content);

    expect(feedIndex.el).toEqual($content);
    expect(feedIndex.reloadOk).toEqual(false);
    expect(feedIndex.canCreatePost).toEqual(true);
    expect(feedIndex.instagramShow).toEqual(true);
    expect(feedIndex.facebookShow).toEqual(true);
    expect(feedIndex.twitterShow).toEqual(true);
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
      feedIndex.reloadOk = false;

      feedIndex.initialFeedSuccess(initialFeedResponse);

      expect(feedIndex.reloadOk).toEqual(true);
      expect($('#feed_container')).toContainText('@TechCrunch');
    });
  });

  describe("toggling posts", function () {
      afterEach(function () {
        $('#jasmine_content').empty();
      });

    it("can toggle twitter posts", function () {
      var fixture1 = $('<aside><ul id="secondary_nav"><li><a href="#" id="twitter_toggle">Toggle Twitter</a></li></ul></aside>');
      var fixture2 = $(TestResponses.initialFeedResponse.success.responseText);
      $('#jasmine_content').append(fixture1);
      $('#jasmine_content').append(fixture2);

      feedIndex = new FeedIndex($('#jasmine_content'));
      expect(feedIndex.twitterShow).toEqual(true);
      feedIndex.toggleTwitterPosts(feedIndex.toggleProvider);

      $('#twitter_toggle').click();
      expect(feedIndex.twitterShow).toEqual(false);
      expect($('.twitter_post')[0]).toBeHidden();
    });

    it("can toggle facebook posts", function () {
      var fixture1 = $('<aside><ul id="secondary_nav"><li><a href="#" id="facebook_toggle">Toggle Facebook</a></li></ul></aside>');
      var fixture2 = $(TestResponses.facebookPost.success.responseText);
      $('#jasmine_content').append(fixture1);
      $('#jasmine_content').append(fixture2);

      feedIndex = new FeedIndex($('#jasmine_content'));
      expect(feedIndex.facebookShow).toEqual(true);
      feedIndex.toggleFacebookPosts(feedIndex.toggleProvider);

      $('#facebook_toggle').click();
      expect(feedIndex.facebookShow).toEqual(false);
      expect($('.facebook_post')[0]).toBeHidden();
    });

    it("can toggle instagram posts", function () {
      var fixture1 = $('<aside><ul id="secondary_nav"><li><a href="#" id="instagram_toggle">Toggle Instagram</a></li></ul></aside>');
      var fixture2 = $(TestResponses.instagramPost.success.responseText);
      $('#jasmine_content').append(fixture1);
      $('#jasmine_content').append(fixture2);

      feedIndex = new FeedIndex($('#jasmine_content'));
      expect(feedIndex.instagramShow).toEqual(true);
      feedIndex.toggleInstagramPosts(feedIndex.toggleProvider);

      $('#instagram_toggle').click();
      expect(feedIndex.instagramShow).toEqual(false);
      expect($('.instagram_post')[0]).toBeHidden();
    });
  });
});