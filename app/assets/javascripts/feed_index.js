var FeedIndex;

FeedIndex = function () {
  function FeedIndex(element) {
    this.el = element;
    this.reloadOk = false;
    this.canCreatePost = true;
  }

  FeedIndex.prototype.initialize = function () {
    var self = this;
    self.getInitialFeed();
    self.setupInfiniteScroll();
    self.setupCreatingPost();
    self.createPost();
    self.twitterFavorite();
    self.twitterRetweet();
    self.instagramLike();
    self.facebookLike();
    self.showInstagramComments();
    self.hideInstagramComments();
    self.showFacebookComments();
    self.hideFacebookComments();
  };

  FeedIndex.prototype.getInitialFeed = function () {
    var self = this;
    $.get("/feed_content").success(function (response) {
      var loadingMessage = $(".loading_message");
      loadingMessage.before(response);
      loadingMessage.hide();
    }).success(function () {
      self.reloadOk = true;
      $("abbr.timeago").timeago();
      $("abbr.timeago").css("border", "none")
    });
  };

  FeedIndex.prototype.setupInfiniteScroll = function () {
    var self = this;
    $(self.el).scroll(function () {
      var scrollbarPosition = $(this).scrollTop();
      var documentHeight = $(this).height();
      if (documentHeight - scrollbarPosition < 7500 && self.reloadOk === true) {
        $(".loading_message").show();
        var nextPageUrl = $(".load_posts_link a").attr("href");
        self.reloadOk = false;
        $.get(nextPageUrl).success(function (response) {
          self.reloadOk = true;
          $(".load_posts_link").replaceWith(response);
          $(".loading_message").hide();
          $("abbr.timeago").timeago();
          $("abbr.timeago").css("border", "none")
        });
      }
    });
  };

  FeedIndex.prototype.setupCreatingPost = function () {
    var self = this;
    $(self.el).on('click', '.create_post_link', function (event) {
      event.preventDefault();
      if (self.canCreatePost) {
        self.canCreatePost = false;
        var div = JST['templates/create_post'](self.providers);
        $('#feed_content').before($(div).fadeIn('slow'));
      }
    });
  };

  FeedIndex.prototype.createPost = function () {
    var self = this;
    $(self.el).on('submit', '#create_post_form', function (event) {
      event.preventDefault();
      var post = $(this)[0][2].value;
      var twitter;
      var facebook;
      var postCheckboxContainer = $(this).find('#post_checkbox_container');
      if (postCheckboxContainer.children('#provider_twitter').length > 0) {
        twitter = postCheckboxContainer.children('#provider_twitter')[0].checked;
      }
      if (postCheckboxContainer.children('#provider_facebook').length > 0) {
        facebook = postCheckboxContainer.children('#provider_facebook')[0].checked;
      }
      var url = $(this).data('behavior');
      $.post(url + "?" + "post=" + post + "&" + "twitter=" + twitter + "&" + "facebook=" + facebook).success(function (response) {
        if (response.unauthed_accounts.length >= 1) {
          var unauthed_accounts = JST['templates/unauthed_accounts'](response);
          $("#feed_container").prepend(unauthed_accounts);
        } else {
          response.images = self.images;
          if (response.tweet !== null) {
            var twitter_div = JST['templates/twitter_post'](response);
            $("#feed_container").prepend(twitter_div);
          }
          if (response.facebook_post !== null) {
            var facebook_div = JST['templates/facebook_post'](response);
            $("#feed_container").prepend(facebook_div);
          }
          $("abbr.timeago").timeago();
          $("abbr.timeago").css("border", "none")
        }
        $("#create_post_form").remove();
        self.canCreatePost = true;
      });
    });
  };

  FeedIndex.prototype.twitterFavorite = function () {
    var self = this;
    $(self.el).on('click', '[data-twitter-favorite-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        target.find('.js-twitter-favorite-count').html(response.favorite_count);
      });
    });
  };

  FeedIndex.prototype.twitterRetweet = function () {
    var self = this;
    $(self.el).on('click', '[data-twitter-retweet-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        target.find('.js-twitter-retweet-count').html(response.retweet_count);
      });
    });
  };

  FeedIndex.prototype.instagramLike = function () {
    var self = this;
    $(self.el).on('click', '[data-instagram-like-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        target.find('.js-instagram-like-count').html(response.likes.count);
      });
    });
  };

  FeedIndex.prototype.facebookLike = function () {
    var self = this;
    $(self.el).on('click', '[data-facebook-like-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        target.find('.js-facebook-like-count').html(response.likes.data.length);
      });
    });
  };

  FeedIndex.prototype.showInstagramComments = function () {
    var self = this;
    $(self.el).on('click', '.instagram_show_comments_link', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.get(endpoint).success(function (response) {
        $(target).closest('li').hide();
        target.parent().children('.instagram_hide_comments').css('display', 'inline-block');
        var postStats = target.closest('.post_stats');
        var instagramComments = JST['templates/instagram_comments'](response);
        $(postStats).after(instagramComments);
      });
    });
  };

  FeedIndex.prototype.hideInstagramComments = function () {
    var self = this;
    $(self.el).on('click', '.instagram_hide_comments', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      target.hide();
      target.parent().children('[data-instagram-comments]').show();
      $(target).parent().parent().parent().find('.post_comments').remove();
    });
  };

  FeedIndex.prototype.showFacebookComments = function () {
    var self = this;
    $(self.el).on('click', '.facebook_show_comments_link', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.get(endpoint).success(function (response) {
        var commentsInformation = Object.create(Object);
        commentsInformation.commentsCount = response.comments.length;
        commentsInformation.postId = target.data('facebookComments');
        var postStats = target.closest('.post_stats');
        var facebookComments = JST['templates/facebook_comments'](response);
        var facebookViewStats = JST['templates/facebook_view_comments_count'](commentsInformation);
        var facebookHideStats = JST['templates/facebook_hide_comments_count'](commentsInformation);
        target.parent().children('.facebook_hide_comments').replaceWith(facebookHideStats);
        target.parent().children('.facebook_hide_comments').css('display', 'inline-block');
        target.parent().children('.facebook_hide_comments').show();
        $(postStats).find('[data-facebook-comments]').replaceWith(facebookViewStats);
        $(postStats).find('[data-facebook-comments]').hide();
        $(postStats).after(facebookComments);
      });
    });
  };

  FeedIndex.prototype.hideFacebookComments = function () {
    var self = this;
    $(self.el).on('click', '.facebook_hide_comments', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      target.hide();
      target.parent().children('[data-facebook-comments]').show();
      $(target).parent().parent().parent().find('.post_comments').remove();
    });
  };

  return FeedIndex;
}();
