FeedIndex = {

  initialize: function () {
    $.get("/feed_content").success(function (response) {
      $(".loading_message").before(response);
      $(".loading_message").hide();
    });

    var reloadOk = true;

    $(document).scroll(function () {
      var scrollbarPosition = $(this).scrollTop();
      var documentHeight = $(this).height();

      if (documentHeight - scrollbarPosition < 7500) {
        $(".loading_message").show();

        var nextPageUrl = $(".load_posts_link a").attr("href");
        if (reloadOk === true) {
          $.ajax({
            url: nextPageUrl,
            beforeSend: function () {
              reloadOk = false
            }
          })
            .success(function (response) {
              reloadOk = true;
              $(".load_posts_link").replaceWith(response);
              $(".loading_message").hide();
            });
        }
      }
    });
  }
};