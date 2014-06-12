FeedIndex = {

  initialize: function () {
    $.get("/feed_content").success(function (response) {
      $(".loading_message").before(response);
      $(".loading_message").hide();
    }).success(function () {
      reloadOk = true
    });

    var reloadOk = false;

    $(document).scroll(function () {
      var scrollbarPosition = $(this).scrollTop();
      var documentHeight = $(this).height();

      if (documentHeight - scrollbarPosition < 7500 && reloadOk === true) {
        $(".loading_message").show();
        var nextPageUrl = $(".load_posts_link a").attr("href");
        reloadOk = false;
        $.get(nextPageUrl).success(function (response) {
          reloadOk = true;
          $(".load_posts_link").replaceWith(response);
          $(".loading_message").hide();
        });
      }
    });

    $(document).on('click', '[data-twitter-favorite-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        target.find('.js-twitter-favorite-count').html(response.favorite_count);
      });
    });

    $(document).on('click', '[data-twitter-retweet-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        var tweet = response.tweet;
        target.find('.js-twitter-retweet-count').html(tweet.retweet_count);
      });
    });

    $(document).on('click', '[data-instagram-like-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        target.find('.js-instagram-like-count').html(response.likes.count);
      });
    });

    $(document).on('click', '[data-facebook-like-count]', function (event) {
      event.preventDefault();
      var target = $(event.target).closest('li');
      var endpoint = target.find('a').attr('href');
      $.post(endpoint).success(function (response) {
        target.find('.js-facebook-like-count').html(response.likes.data.length);
      });
    });
  }

};




