PostValidator = {
  validatePostTextarea: function (textareaValue) {
    if (textareaValue === null || textareaValue === "") {
      $('#textarea_validation_error').show();
      $('#tweet_length_validation_error').hide();
      return false;
    } else {
      $('#textarea_validation_error').hide();
      return true;
    }
  },

  validatePostCheckboxes: function (checkboxes) {
    var counter = 0;
    for (var i = 0; i < checkboxes.length; i++) {
      if (checkboxes[i].checked) {
        counter += 1;
      }
    }
    if (counter > 0) {
      $('#checkbox_validation_error').hide();
      return true;
    } else {
      $('#checkbox_validation_error').show();
      return false;
    }
  },

  validateTweetLength: function (tweetText) {
    if (tweetText.length > 140) {
      $('#tweet_length_validation_error').show();
      return false;
    } else {
      $('#tweet_length_validation_error').hide();
      return true;
    }
  }
};