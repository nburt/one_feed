var FeedIndex;

FeedIndex = function () {
  function FeedIndex(element) {
    this.el = element;
    this.reloadOk = false;
    this.canCreatePost = true;
  }

  FeedIndex.prototype.initialize = function () {
    this.toggleProviderButtons();
    this.getInitialFeed(this.initialFeedSuccess);
    this.trackScrolling(this.nextFeedSuccess);
    this.setupCreatingPost();
    this.createPost(this.createPostSuccess.bind(this), this.validatePostTextarea, this.validatePostCheckboxes);
    this.cancelCreatePost();
    this.twitterFavorite(this.twitterFavoriteSuccess);
    this.twitterRetweet(this.twitterRetweetSuccess);
    this.instagramLike(this.instagramLikeSuccess);
    this.facebookLike(this.facebookLikeSuccess);
    this.showInstagramComments(this.showInstagramCommentsSuccess);
    this.hideInstagramComments(this.hideProviderComments);
    this.showFacebookComments(this.showFacebookCommentsSuccess);
    this.hideFacebookComments(this.hideProviderComments);
    this.toggleFacebookPosts(this.toggleProvider);
    this.toggleTwitterPosts(this.toggleProvider);
    this.toggleInstagramPosts(this.toggleProvider);
  };

  FeedIndex.prototype.setProviders = function (providers) {
    if (providers.facebook !== undefined) {
      this.providers.facebook = providers.facebook;
    }
    if (providers.twitter !== undefined) {
      this.providers.twitter = providers.twitter;
    }
    if (providers.instagram !== undefined) {
      this.providers.instagram = providers.instagram;
    }
  };

  FeedIndex.prototype.toggleProviderButtons = function () {
    if (this.providers.twitter) {
      $('#twitter_toggle').show();
    } else {
      $('#twitter_toggle').hide();
    }
    if (this.providers.instagram) {
      $('#instagram_toggle').show();
    } else {
      $('#instagram_toggle').hide();
    }
    if (this.providers.facebook) {
      $('#facebook_toggle').show();
    } else {
      $('#facebook_toggle').hide();
    }
  };

  FeedIndex.prototype.getInitialFeed = function (initialFeedSuccess) {
    $.get("/feed_content").success(initialFeedSuccess.bind(this));
  };

  FeedIndex.prototype.initialFeedSuccess = function (response) {
    this.render(response);
    this.reloadOk = true;
    this.addTimeagoPlugin();
  };

  FeedIndex.prototype.render = function (response) {
    $('#feed_container').append(response.fragment);
    var providers = {};
    for (var i = 0; i < response.unauthed_accounts.length; i++) {
      providers[response.unauthed_accounts[i]] = false;
    }
    this.setProviders(providers);
    this.toggleProviderButtons();
    $(".loading_message").hide();
  };

  FeedIndex.prototype.addTimeagoPlugin = function () {
    $("abbr.timeago").timeago();
    $("abbr.timeago").css("border", "none")
  };

  FeedIndex.prototype.trackScrolling = function (nextFeedSuccess) {
    $(this.el).scroll(function () {
      var scrollbarPosition = $(this.el).scrollTop();
      var documentHeight = $(this.el).height();
      if (this.isReloadAvailable(documentHeight, scrollbarPosition)) {
        $(".loading_message").show();
        var nextPageUrl = $(".load_posts_link a").attr("href");
        this.reloadOk = false;
        $.get(nextPageUrl).success(nextFeedSuccess.bind(this));
      }
    }.bind(this));
  };

  FeedIndex.prototype.isReloadAvailable = function (documentHeight, scrollbarPosition) {
    return (documentHeight - scrollbarPosition < 7500 && this.reloadOk === true && (this.providers.instagram || this.providers.facebook || this.providers.twitter ));
  };

  FeedIndex.prototype.nextFeedSuccess = function (response) {
    this.reloadOk = true;
    if ($('.unauthed_accounts').length === 1) {
      this.nextFeedUnauthedAccounts(response);
    } else {
      $(".load_posts_link").replaceWith(response.fragment);
    }
    this.toggleProviderButtons();
    $(".loading_message").hide();
    this.addTimeagoPlugin();
    this.hidePosts();
  };

  FeedIndex.prototype.nextFeedUnauthedAccounts = function (response) {
    var originalUnauthedAccountsCount = $('.unauthed_accounts').find('li').length;
    $(".load_posts_link").replaceWith(response.fragment);
    if ($('.unauthed_accounts').length === 1) {
      this.providers = {facebook: true, twitter: true, instagram: true};
      $('.unauthed_accounts').remove();
    } else {
      if (originalUnauthedAccountsCount === $('.unauthed_accounts:last').find('li').length) {
        $('.unauthed_accounts:last').remove();
      } else {
        $('.unauthed_accounts:last').remove();
        this.providers = {facebook: true, twitter: true, instagram: true};
        $('.unauthed_accounts').replaceWith(JST['templates/unauthed_accounts'](response));
        for (var i = 0; i < $('[data-unauthed]').length; i++) {
          var unauthedProvider = $($('[data-unauthed]')[i]).data('unauthed');
          this.providers[unauthedProvider] = false;
        }
      }
    }
  };

  FeedIndex.prototype.hidePosts = function () {
    if (!this.providers.instagram) {
      $('.instagram_post').hide();
    }
    if (!this.providers.facebook) {
      $('.facebook_post').hide();
    }
    if (!this.providers.twitter) {
      $('.twitter_post').hide();
    }
  };

  FeedIndex.prototype.setupCreatingPost = function () {
    $(this.el).on('click', '.create_post_link', function (event) {
      event.preventDefault();
      if (this.canCreatePost) {
        this.canCreatePost = false;
        var div = JST['templates/create_post'](this.providers);
        $('#feed_content').before($(div).fadeIn('slow'));
      }
    }.bind(this));
  };

  FeedIndex.prototype.createPost = function (createPostSuccess, validatePostTextarea, validatePostCheckboxes) {
    $(this.el).on('submit', '#create_post_form', function (event) {
      event.preventDefault();
      if (validatePostTextarea() && validatePostCheckboxes()) {
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
        $.post(url + "?" + "post=" + post + "&" + "twitter=" + twitter + "&" + "facebook=" + facebook).success(createPostSuccess);
      }
    });
  };

  FeedIndex.prototype.cancelCreatePost = function () {
    $(this.el).on('click', '#js-cancel-button', function (event) {
      event.preventDefault();
      $("#create_post_form").remove();
    });
  };

  FeedIndex.prototype.validatePostTextarea = function () {
    var textareaValue = document.forms.create_post_form.post.value;
    if (textareaValue == null || textareaValue == "") {
      alert("Post body cannot be blank.");
      return false;
    } else {
      return true;
    }
  };

  FeedIndex.prototype.validatePostCheckboxes = function () {
    var checkboxes = $(document.forms.create_post_form).find('input[type=checkbox]');
    if (!checkboxes[0].checked && !checkboxes[1].checked) {
      alert("You must check at least one provider.");
      return false;
    } else {
      return true;
    }
  };

  FeedIndex.prototype.createPostSuccess = function (response) {
    if (response.unauthed_accounts.length >= 1) {
      var unauthed_accounts = JST['templates/unauthed_accounts'](response);
      $("#feed_container").prepend(unauthed_accounts);
    } else {
      response.images = this.images;
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
    this.canCreatePost = true;
  };

  FeedIndex.prototype.twitterFavorite = function (twitterFavoriteSuccess) {
    $(this.el).on('click', '[data-twitter-favorite-count]', function (event) {
      event.preventDefault();
      var $target = $(event.target).closest('li');
      var endpoint = $target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        twitterFavoriteSuccess($target, response);
      });
    }.bind(this));
  };

  FeedIndex.prototype.twitterFavoriteSuccess = function ($target, response) {
    $target.find('.js-twitter-favorite-count').html(response.favorite_count);
  };

  FeedIndex.prototype.twitterRetweet = function (twitterRetweetSuccess) {
    $(this.el).on('click', '[data-twitter-retweet-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        twitterRetweetSuccess(target, response);
      });
    }.bind(this));
  };

  FeedIndex.prototype.twitterRetweetSuccess = function (target, response) {
    target.find('.js-twitter-retweet-count').html(response.retweet_count);
  };

  FeedIndex.prototype.instagramLike = function (instagramLikeSuccess) {
    $(this.el).on('click', '[data-instagram-like-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        instagramLikeSuccess(target, response);
      });
    }.bind(this));
  };

  FeedIndex.prototype.instagramLikeSuccess = function (target, response) {
    target.find('.js-instagram-like-count').html(response.likes.count);
  };

  FeedIndex.prototype.facebookLike = function (facebookLikeSuccess) {
    $(this.el).on('click', '[data-facebook-like-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        facebookLikeSuccess(target, response);
      });
    }.bind(this));
  };

  FeedIndex.prototype.facebookLikeSuccess = function (target, response) {
    target.find('.js-facebook-like-count').html(response.likes.data.length);
  };

  FeedIndex.prototype.showInstagramComments = function (showInstagramCommentsSuccess) {
    $(this.el).on('click', '.instagram_show_comments_link', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.get(endpoint).success(function (response) {
        showInstagramCommentsSuccess(target, response)
      });
    }.bind(this));
  };

  FeedIndex.prototype.showInstagramCommentsSuccess = function (target, response) {
    var commentsInformation = Object.create(Object);
    commentsInformation.commentsCount = response.comments.length;
    commentsInformation.postId = target.data('instagramComments');
    var postStats = target.closest('.post_stats');
    var instagramComments = JST['templates/instagram_comments'](response);
    var instagramViewStats = JST['templates/instagram_view_comments_count'](commentsInformation);
    var instagramHideStats = JST['templates/instagram_hide_comments_count'](commentsInformation);
    target.parent().children('.instagram_hide_comments').replaceWith(instagramHideStats);
    target.parent().children('.instagram_hide_comments').css('display', 'inline-block');
    target.parent().children('.instagram_hide_comments').show();
    $(postStats).find('[data-instagram-comments]').replaceWith(instagramViewStats);
    $(postStats).find('[data-instagram-comments]').hide();
    $(postStats).after(instagramComments);
  };

  FeedIndex.prototype.hideInstagramComments = function (hideProviderComments) {
    $(this.el).on('click', '.instagram_hide_comments_link', function (event) {
      hideProviderComments('[data-instagram-comments]', event);
    });
  };

  FeedIndex.prototype.showFacebookComments = function (showFacebookCommentsSuccess) {
    $(this.el).on('click', '.facebook_show_comments_link', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.get(endpoint).success(function (response) {
        showFacebookCommentsSuccess(target, response);
      });
    });
  };

  FeedIndex.prototype.showFacebookCommentsSuccess = function (target, response) {
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
  };

  FeedIndex.prototype.hideFacebookComments = function (hideProviderComments) {
    $(this.el).on('click', '.facebook_hide_comments_link', function (event) {
      hideProviderComments('[data-facebook-comments]', event);
    });
  };

  FeedIndex.prototype.hideProviderComments = function (providerData, event) {
    event.preventDefault();
    var target = $(event.target).closest('li');
    target.hide();
    target.parent().children(providerData).show();
    $(target).parent().parent().parent().find('.post_comments').remove();
  };

  FeedIndex.prototype.toggleProvider = function (className, providerVisibility) {
    this.providers[providerVisibility] = !this.providers[providerVisibility];
    $(className).toggle();
  };

  FeedIndex.prototype.toggleFacebookPosts = function (toggleProvider) {
    $(this.el).on('click', '#facebook_toggle', function (event) {
      event.preventDefault();
      toggleProvider.apply(this, [$('.facebook_post'), 'facebook']);
    }.bind(this));
  };

  FeedIndex.prototype.toggleTwitterPosts = function (toggleProvider) {
    $(this.el).on('click', '#twitter_toggle', function (event) {
      event.preventDefault();
      toggleProvider.apply(this, [$('.twitter_post'), 'twitter']);
    }.bind(this));
  };

  FeedIndex.prototype.toggleInstagramPosts = function (toggleProvider) {
    $(this.el).on('click', '#instagram_toggle', function (event) {
      event.preventDefault();
      toggleProvider.apply(this, [$('.instagram_post'), 'instagram']);
    }.bind(this));
  };

  return FeedIndex;
}();
